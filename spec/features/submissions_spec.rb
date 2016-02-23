require 'rails_helper'

feature "zgloszenia" do

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "sprawdzenie czy jest odnosnik prowadzacy do zgloszen w menu" do
      visit '/issues/'
      click_on('Zgłoszone artykuły')

      expect(page).to have_css(".btn", text: "Nowe zgłoszenie")
    end

    scenario "sprawdzenie czy przenosi do strony submission/new" do
      visit '/submissions/'
      click_on('Nowe zgłoszenie')

      expect(page).to have_css(".form-group")
    end

    context "redaktor w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                       "mężczyzna", roles: ['redaktor', 'recenzent'], discipline:["psychologia"])
        Issue.create!(volume: 3, year: 2020)
        Issue.create!(volume: 4, year: 2020)
      end

      scenario "tworzenie nowego zgloszenia" do
        visit '/submissions/new/'
        within("#new_submission") do
          fill_in "Tytuł", with: "Testowy tytuł zgłoszenia"
          fill_in "Title", with: "English title"
          fill_in "Abstract", with: "absbabsba"
          fill_in "Key words", with: "englsh key words"
          select "Andrzej Kapusta", from: "Redaktor"
          select "nadesłany", from: "Status"
          select "3/2020", from: "Numer"
        end
        click_button("Utwórz")

        expect(page).not_to have_css(".has-error")
        expect(page).to have_content("Testowy tytuł zgłoszenia")
      end


      context "2 zgłoszenia w bazie danych" do
        before do
          Submission.create!(person: Person.first, status: "odrzucony", polish_title: "Alicja w krainie czarów",
                             english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                             english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
          Submission.create!(person: Person.first, status: "do poprawy", polish_title: "W pustyni i w puszczy",
                             english_title: "Desert and something", english_abstract: "Super lecture", english_keywords:
                             "desert", received: "11-01-2016", language: "polski", issue: Issue.last)
          Submission.create!(person: Person.first, status: "nadesłany", polish_title: "Zupa",
                             english_title: "Soup", english_abstract: "Soup is good", english_keywords:
                             "soup", received: "11-01-2016", language: "polski", issue: Issue.last)
        end

        scenario "Sprawdzenie linku do numeru" do
          visit "/submissions"
          click_on("Alicja w krainie czarów")
          click_on("3/2020")

          expect(page).to have_content("Numer 3/2020")
        end

        scenario "Filtrowanie zgłoszeń po statusie" do
          visit "/submissions"

          select "odrzucony", from: "Status"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end

        scenario "Filtrowanie zgłoszeń po tytule" do
          visit "/submissions"

          fill_in "Tytuł", with: "Alicja w krainie czarów"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end

        scenario "Filtrowanie zgłoszeń po numerze rocznika" do
          visit "/submissions"

          select "3/2020", from: "Numer rocznika"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end

        scenario "Filtrowanie zgłoszeń po statusie" do
          visit "/submissions"

          fill_in "Data początkowa", with: "19/1/2016"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end
        
        scenario "Filtrowanie po języku" do
          visit "/submissions"
          
          select "polski", from: "Język"
          
          click_on("Filtruj")
          expect(page).to have_content(/Alicja w krainie czarów.*W pustyni i w puszczy/)
        end
        
        scenario "Filtrowanie po języku" do
          visit "/submissions"
          
          select "angielski", from: "Język"
        
          click_on("Filtruj")
          expect(page).not_to have_content(/Alicja w krainie czarów.*W pustyni i w puszczy/) 
        end

        scenario "Wyświetlanie braku dealine'u" do
          visit '/submissions'

          expect(page).to have_content("[BRAK DEADLINE'u]")
        end

        scenario "Wyświetlanie przypisanego numeru" do
          visit '/submissions'
          click_link('3/2020', match: :first)
          expect(page).to have_content('Numer 3/2020')
          expect(page).to have_content("Alicja w krainie czarów")
        end

        scenario "edycja zgloszenia" do
          visit "/submissions/"
          click_on("W pustyni i w puszczy")
          click_on("Edytuj")
          fill_in "Otrzymano", with: "16/07/2016"
          click_on("Zapisz")

          expect(page).not_to have_css(".has-error")
          expect(page).to have_content("16-07-2016")
        end

        scenario "sortowanie zgłoszeń względem daty nadesłania" do
          visit "/submissions"
          click_on("Data nadesłania")
          expect(page).to have_content(/11-01-2016.*19-01-2016/)
          click_on("Data nadesłania")
          expect(page).to have_content(/19-01-2016.*11-01-2016/)
        end


        context "Z recenzją" do
          before do
            revision =
              ArticleRevision.create!(submission: Submission.first,
                                      article: File.new(Rails.root + 'app/assets/images/remind_icon.png'), pages: 1,
                                      pictures: 1, version: 1)
            Review.create!(article_revision: revision, deadline: '28/01/2016', person: Person.first,
                           status: "recenzja pozytywna", asked: '1/01/2016')
          end

          scenario "Wyświetlanie dealine'u" do
            visit '/submissions'

            expect(page).to have_content('28-01-2016')
          end

          scenario "wysłanie przypomnienia o recenzji" do
            visit '/submissions'
            clear_emails
            click_on("Alicja w krainie czarów")
            page.find(".reminder").click
            expect(page).to have_css(".flash-confirmation")
            open_email('a.kapusa@gmail.com')
            expect(current_email).to have_content 'Z poważaniem,'
            expect(current_email).to have_content 'Kapusta'
            expect(current_email).to have_content 'remind_icon.png'
          end
        end
      end

      context "brak autora w bazie danych" do
        before do
          person = Person.create!(name: "Andrzej", surname: "Kapusta", email:
                                  "a.kapusa@gmail.com", sex: "mężczyzna", roles: ['redaktor'])
          Submission.create!(status: "nadesłany", language: "polski", person: person, received: "20-01-2016",
                             polish_title: "Bukiet kotów", english_title: "cats", english_abstract: "Sth about cats",
                             english_keywords: "cats cat")
        end

        scenario "dodanie autora do zgłoszenia bez autorów w bazie danych" do
          visit '/submissions'
          click_on("Bukiet kotów")
          click_on("Dodaj autora")
          click_button("Dodaj")

          expect(page).to have_css(".has-error")
        end

        xscenario "reset filtrów i formularza" do
          visit "/submissions"
          fill_in "Tytuł", with: "Ten nudny"
          expect(page).to have_xpath("//input[@value='Ten nudny']")
          click_button 'x'
          find_field('Tytuł').value.blank?
          select "odrzucony", from: "Status"
          fill_in "Data początkowa", with: "12/2/2016"
          select "3/2020", from: "Numer rocznika"
          click_button 'Filtruj'
          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
          click_button 'x'
          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).to have_content("W pustyni i w puszczy")
        end
      end

      context "historia zgloszen" do
        before do
          person = Person.create!(name: "Andrzej", surname: "Sałata", email:
                                                     "a.salata@gmail.com", sex: "mężczyzna", roles: ['autor'])
          issue = Issue.create!(volume: 12, year: 2020)
          Submission.create!(person: person, status: "u redaktora", polish_title: "Alicja w krainie czarów",
                             english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                             english_keywords: "alice", received: "19-01-2016", language: "polski", issue: issue)
        end


        scenario "wyswietlenie historii po utworzeniu zgloszenia" do
          visit '/submissions'

          expect(page).to have_content("Alicja w krainie czarów")

          click_on("Alicja w krainie czarów")

          expect(page).to have_content("1")
          expect(page).to have_content("Obecna")
          expect(page).to have_content("u redaktora")
        end

        scenario "wyswietlenie nowej pozycji w historii, po zmianie statusu zgloszenia" do
          visit '/submissions'
          expect(page).to have_content("Alicja w krainie czarów")
          click_on("Alicja w krainie czarów")

          click_on ("Edytuj")
          select('przyjęty', :from => 'submission_status')
          click_on ("Zapisz")

          visit '/submissions'
          expect(page).to have_content("Alicja w krainie czarów")
          click_on("Alicja w krainie czarów")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).to have_content("1")
          expect(page).to have_content("2")
          expect(page).to have_content("Obecna")
          expect(page).to have_content("u redaktora")
          expect(page).to have_content("przyjęty")
        end

      end
    end
  end
end
