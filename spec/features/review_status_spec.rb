require 'rails_helper'

feature "filtrowanie recenzji po statusie" do
  scenario "zarządzanie osobami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

     scenario "link do nowej recenzji" do
      visit '/reviews/new'

      expect(page).to have_css("#new_review input[value='Dodaj']")
    end
  end

    scenario "tworzenie nowej recenzji" do
      visit '/reviews/new'

      within("#new_review") do
        fill_in "Artykuł (wersja)", with: "Nowy artykuł"
        fill_in "Recenzent", with: "Ada Kowalska"
        fill_in "Status", with: "wysłane zaytanie"
        fill_in "Zapytanie wysłano", with: "18-01-2016"
        fill_in "Deadline", with: "03-03-2016"
        fill_in "Uwagi", with: "brak"
      end
      click_button 'Dodaj'
        expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Ada Kowalska")
    end

    scenario "tworzenie nowej recenzji" do
      visit '/reviews/new'

      within("#new_review") do
        fill_in "Artykuł (wersja)", with: "Nowy artykuł1"
        fill_in "Recenzent", with: "Ada Kowalska"
        fill_in "Status", with: "recenzja przyjęta"
        fill_in "Zapytanie wysłano", with: "19-01-2016"
        fill_in "Deadline", with: "04-03-2016"
        fill_in "Uwagi", with: "brak"
      end
      click_button 'Dodaj'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Ada Kowalska")
    end

    scenario "tworzenie nowej recenzji" do
      visit '/reviews/new'

      within("#new_review") do
        fill_in "Artykuł (wersja)", with: "Nowy artykuł2"
        fill_in "Recenzent", with: "Ada Kowalska"
        fill_in "Status", with: "recenzja przyjęta"
        fill_in "Zapytanie wysłano", with: "11-01-2016"
        fill_in "Deadline", with: "05-03-2016"
        fill_in "Uwagi", with: "brak"
      
      click_button 'Dodaj'
    
      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Ada Kowalska")
    end
  end
end
