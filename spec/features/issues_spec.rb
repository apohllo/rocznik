require 'rails_helper'

feature "zarządzanie numerami" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/issues'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "link do nowego numeru" do
      visit '/issues'
      click_link 'Nowy numer'

      expect(page).to have_css("#new_issue input[value='Utwórz']")
    end

    scenario "tworzenie nowego numeru" do
      visit '/issues/new'

      within("#new_issue") do
        fill_in "Rok", with: 2015
        fill_in "Numer", with: 10
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("2015")
      expect(page).to have_content("10")
    end

    scenario "tworzenie nowego numeru z brakującymi elementami" do
      visit '/issues/new'

      within("#new_issue") do
        fill_in "Rok", with: 2015
      end
      click_button 'Utwórz'

      expect(page).to have_css(".has-error")
    end

    context "z dwoma numerami w bazie danych" do
      before do
        Issue.create!(year: 2015, volume: 10)
        Issue.create!(year: 2016, volume: 11)
      end

      scenario "wyświetlenie szczegółów numeru" do

        visit "/issues"
        click_link("10")

        expect(page).to have_css("h3", text: "10/2015")
      end
    end
  end
end
