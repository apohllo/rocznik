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
        Person.create!(name: "Andrzej", surname: "Kapusta", discipline: "filozofia", email: "a.kapusa@gmail.com", sex:
                       "mężczyzna", roles: ['redaktor'])
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
          select "3/2020", from: "Nr wydania"
        end
        click_button("Utwórz")

        expect(page).not_to have_css(".has-error")
        expect(page).to have_content("Testowy tytuł zgłoszenia")
      end

      context "2 zgłoszenia w bazie danych" do
        before do
          Submission.create!(person_id: Person.first, status: "odrzucony", polish_title: "Alicja w krainie czarów",
                             english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                             english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
          Submission.create!(person_id: Person.first, status: "do poprawy", polish_title: "W pustyni i w puszczy",
                             english_title: "Desert and something", english_abstract: "Super lecture", english_keywords:
                             "desert", received: "11-01-2016", language: "polski", issue: Issue.last)
        end

        scenario "filtrowanie zgłoszeń po statusie" do
          visit "/submissions"

          select "odrzucony", from: "Status"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end

        scenario "filtrowanie zgłoszeń po numerze rocznika" do
          visit "/submissions"

          select "3/2020", from: "Numer rocznika"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end

        scenario "filtrowanie zgłoszeń po statusie" do
          visit "/submissions"

          fill_in "Data początkowa", with: "19/1/2016"
          click_on("Filtruj")

          expect(page).to have_content("Alicja w krainie czarów")
          expect(page).not_to have_content("W pustyni i w puszczy")
        end
      end

      context "brak autora w bazie danych" do
        before do
          person = Person.create!(name: "Andrzej", surname: "Kapusta", discipline: "filozofia", email:
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
      end
    end
  end
end
