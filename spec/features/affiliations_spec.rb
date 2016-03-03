require 'rails_helper'

feature "Dodawanie Afiliacji" do

  context "po zalogowaniu" do
    include_context "admin login"


    context "Afiliacje" do
      before do
      	Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                   "mężczyzna", roles: ['redaktor', 'recenzent'])
      end

      scenario "Sprawdzenie dodania poprawnej afiliacji" do
        visit '/people/'
        click_on("Kapusta")
        click_on("Dodaj afiliację")

		within("#new_affiliation_composite") do
	        fill_in "Państwo", with: "Polska"
	        fill_in "Instytucja", with: "Uniwersytet Jagielloński"
	        fill_in "Wydział/Instytut", with: "WZKiS"
	        fill_in "Rok od", with: "2014"
	        fill_in "Rok_do", with: "2016"
	    end
        click_button 'Dodaj'

        expect(page).to have_content("Uniwersytet Jagielloński")
      end
    end
  end
end