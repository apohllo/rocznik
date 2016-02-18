require 'rails_helper'


feature "Formularz dodania proponowanych recenzentów" do
   
end
scenario "Dodawanie proponowanego recenzenta" do
      visit '/public_reviews/new_reviewer'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
        fill_in "Nazwisko", with: "Kapusta"
        fill_in "E-mail", with: "a.kapusta@gmail.com"
        select "mężczyzna", from: "Płeć", visible: false
      end
      click_button 'Dodaj propozycję'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Andrzej")
      expect(page).to have_content("Kapusta")
    end
