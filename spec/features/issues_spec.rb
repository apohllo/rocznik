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
          select "3/2020", from: "Nr wydania"
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

        context "przygotowany do wydania" do
          before do
            Issue.first.update_attributes(prepared: true)
            Article.create!(issue: Issue.first, submission:Submission.first)
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
              visit "/submissions"
              expect(page).to have_css("li a",text: "3/2020")
            end
            scenario "Wyświetl wydany numer jako niezalogowany użytkownik" do
              visit "/public_issues"

              click_link "Wyloguj"
              click_link "3/2020"
              expect(page).to have_content("[autor nieznany]; 'Zaakceptowany tytuł'")
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
    end
  end
end
