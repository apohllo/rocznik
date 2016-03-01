require 'rails_helper'

feature "zarządzanie numerami" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/issues'

    expect(page).to have_content 'Zaloguj się'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "dostępność numerów w menu" do
      visit '/people'

      expect(page).to have_link("Numery rocznika")
    end

    scenario "wyświetlanie pustej listy numerów" do
      visit '/issues'

      expect(page).to have_css("h3", text: "Numery rocznika")
    end

    scenario "link do nowego numeru" do
      visit '/issues'
      click_link 'Nowy numer'

      expect(page).to have_css("#new_issue input[value='Utwórz']")
    end

    scenario "tworzenie nowego numeru" do
      visit '/issues/new'

      within("#new_issue") do
        fill_in "Numer", with: 2
        fill_in "Rok", with: 2017
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content(2)
      expect(page).to have_content(2017)
    end

    context "proba test" do
      before do
        Issue.create!(volume: 98, year: 2098)
        Issue.create!(volume: 99, year: 2099)
        Submission.create!(status:'przyjęty', language:"polski", issue:
                           Issue.last, polish_title: "proba",
                           english_title: "test", english_abstract:
                           "english", english_keywords: "test,
                             exam", received: "2015-01-17")

      end

      scenario "sprawdzanie niedostepnosci linku" do
        visit '/issues/98-2098'

        expect(page).to have_css(".disabled")
      end

      scenario "sprawdzanie dostepnosci linku" do
        visit '/issues/99-2099'

        expect(page).not_to have_css(".disabled")
      end

      scenario "przygotowanie numeru do wydania" do
        visit '/issues/99-2099'
        click_link "Przygotuj do wydania"

        expect(page).to have_content("Przygotuj numer do wydania")
      end

      scenario "wyswietlenie publikowanych artykulow" do
        visit '/issues/99-2099/prepare_form'
        click_button "Przygotuj numer do wydania"

        expect(page).to have_content("Publikowane artykuły")
      end
    end

    context "z jednym numerem w bazie danych" do
      before do
        Issue.create!(volume: 3, year: 2020)
      end

      scenario "wyświetlenie szczegółów numeru" do
        visit "/issues"
        click_link "3"

        expect(page).to have_content("Numer 3/2020")
        expect(page).to have_link("Przygotuj do wydania")
      end

      scenario "dostępność edycji numeru" do
        visit "/issues"
        click_link "3"

        expect(page).to have_link("Edytuj")
      end

      scenario "dodawanie zgłoszenia z istniejącym numerem i sprawdzenie zgłoszenia w numerze" do
        visit '/submissions/new'

        within("#new_submission") do
          select "nadesłany", from: "Status"
          select "polski", from: "Język"
          select "3/2020", from: "Numer"
          fill_in "Otrzymano", with: "12-01-2016"
          fill_in "Tytuł", with: "próbny tytuł"
          fill_in "Title", with: "trial"
          fill_in "Abstract", with: "trial abstract"
          fill_in "Key words", with: "trial key words"
        end
        click_button 'Utwórz'

        visit "/issues"
        click_link "3"

        expect(page).to have_content("próbny tytuł")
      end

      context "z jednym zaakceptowanym zgłoszeniem" do
        before do
          Submission.create!(status:'przyjęty', language:"polski", issue:
                             Issue.first, polish_title: "Zaakceptowany tytuł",
                             english_title: "Accepted title", english_abstract:
                             "Short abstract", english_keywords: "brain,
                             language", received: "2016-01-17")
        end

        scenario "Przygotowanie numeru do wydania" do
          visit "/issues"

          click_link "3"
          click_link "Przygotuj do wydania"
          expect(page).to have_content("Wybierz artykuły")

          check 'Zaakceptowany tytuł'
          click_button 'Przygotuj numer do wydania'
          expect(page).not_to have_css(".has-error")
          expect(page).not_to have_content("Wybierz artykuły do wydania")
        end

        context "z jedną recenzją" do
          before do
            Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                           "mężczyzna", roles: ['redaktor', 'recenzent'])
            article_file = Rails.root.join("spec/features/files/plik.pdf").open
            revision = ArticleRevision.create!(submission: Submission.first, received: '19-01-2016',
                                              pages: 1, pictures: 1, version: 1, article: article_file)
            Review.create!(article_revision: revision, deadline: '28/01/2016', person: Person.first,
                           status: "recenzja pozytywna", asked: '1/01/2016', content: "treść rezenzji")
          end

          scenario "dostępność przeglądu recenzji" do
            visit "/issues"

            click_link "3"
            expect(page).to have_link("Pokaż recenzje")
          end

          scenario "wyświetlenie tytułów artykułów oraz treści rezenzji" do
            visit "/issues"

            click_link "3"
            click_link "Pokaż recenzje"
            expect(page).to have_content("Zaakceptowany tytuł")
            expect(page).to have_content("treść rezenzji")
          end
        end
        context "recenzenci" do
          before do
            Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                           "mężczyzna", roles: ['redaktor', 'recenzent'])
            article_file = Rails.root.join("spec/features/files/plik.pdf").open
            revision = ArticleRevision.create!(submission: Submission.first, pages: 1, pictures: 1, version: 1, received: "18-01-2016", article: article_file)
            Review.create!(article_revision: revision, deadline: '28/01/2016', person: Person.first,
                           status: "recenzja pozytywna", asked: '1/01/2016', content: "treść rezenzji")
          end

          scenario "link do listy recenzentów" do
            visit "/issues"

            click_link "3"
            expect(page).to have_link("Pokaż recenzentów")
          end

          scenario "wyświetlenie linku listy recenzentów" do
            visit "/issues"

            click_link "3"
            click_link "Pokaż recenzentów"
            expect(page).to have_content("Andrzej Kapusta")
          end
        end

        context "przygotowany do wydania" do
          before do
            Issue.first.update_attributes(prepared: true)
            Article.create!(issue: Issue.first, submission:Submission.first, status: 'po recenzji')
          end

          scenario "brak numeru na liście wydanych numerów" do
            visit "/submissions"
            expect(page).not_to have_css("li a",text: "3/2020")
          end

          scenario "Wydanie numeru" do
            visit "/issues"
            click_link "3"
            expect(page).to have_content("Wydaj numer")

            click_link "Wydaj numer"
            expect(page).to have_content("3/2020 [OPUBLIKOWANY]")
          end
          context "wydany numer" do
            before do
              Issue.first.update_attributes(published: true)
            end
            scenario "Pojawienie się numeru na liście wydanych numerów" do
              visit "/public_issues"
              expect(page).to have_css("li a",text: "3/2020")
            end
            scenario "Wyświetl wydany numer jako niezalogowany użytkownik" do
              visit "/public_issues"

              click_link "Wyloguj"
              click_link "3/2020"
              expect(page).to have_content(/\[autor nieznany\].*Zaakceptowany tytuł/)
            end
          end
        end
      end

      scenario "Sprawdzenie czy nie da sie utworzyć rocznika z roku mniejszego niż 2000" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 2
          fill_in "Rok", with: 1999
        end
        click_button 'Utwórz'

        expect(page).to have_css(".has-error")
      end

      scenario "Sprawdzenie, czy da sie utworzyc rocznik z nieunikalnym numerem" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 1
          fill_in "Rok", with: 2001
        end
        click_button "Utwórz"

        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 1
          fill_in "Rok", with: 2001
        end
        click_button "Utwórz"

        expect(page).to have_css(".has-error")
      end

      scenario "Sprawdzenie czy da sie utworzyć rocznik z numeru mniejszego niż 1" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 0
          fill_in "Rok", with: 2016
        end
        click_button 'Utwórz'

        expect(page).to have_css(".has-error")
      end

    end
  end
end
