require 'rails_helper'

feature "zarządzanie numerami" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/issues'

    expect(page).to have_content 'Log in'
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
        click_link("3")

        expect(page).to have_content("Numer 3/2020")
        expect(page).to have_link("Przygotuj do wydania")
      end

      scenario "dodawanie zgłoszenia z istniejącym numerem i sprawdzenie zgłoszenia w numerze" do
        visit '/submissions/new'

        within("#new_submission") do
          select "nadesłany", from: "Status"
          select "polski", from: "Język"
          select "3/2020", from: "Nr wydania"
          fill_in "Otrzymano", with: "12-01-2016"
          fill_in "Tytuł", with: "próbny tytuł"
          fill_in "english_title", with: "trial"
        end
        click_button 'Utwórz'

        visit "/issues"
        click_link ("3")

        expect(page).to have_content("próbny tytuł")
      end

      scenario "Przygotowanie numeru do wydania" do
        visit '/submissions/new'

        within("#new_submission") do
          select "przyjęty", from: "Status"
          select "polski", from: "Język"
          select "3/2020", from: "Nr wydania"
          fill_in "Otrzymano", with: "12-01-2016"
          fill_in "Tytuł", with: "Zaakceptowany tytuł"
        end
        click_button 'Utwórz'

        visit "/issues"
        click_link ("3")

        click_link("Przygotuj do wydania")
        expect(page).to have_content("Wybierz artykuły")

        check('Zaakceptowany tytuł')
        click_button 'Przygotuj numer do wydania'

        expect(page).not_to have_css(".has-error")
        expect(page).not_to have_content("Wybierz artykuły do wydania")
      end
    end
  end
end
