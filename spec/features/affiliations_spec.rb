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
	        fill_in "affiliation_composite_country_autocomplete", with: "Polska"
	        fill_in "affiliation_composite_institution_autocomplete", with: "Uniwersytet Jagielloński"
	        fill_in "affiliation_composite_department_autocomplete", with: "WZKiS"
	        fill_in "Rok od", with: "2014"
	        fill_in "Rok do", with: "2016"
	    end
        click_button 'Dodaj'

        expect(page).to have_content("Uniwersytet Jagielloński")
      end

      scenario "Sprawdzenie nie dodania afiliacji" do
        visit '/people/'
        click_on("Kapusta")
        click_on("Dodaj afiliację")

        within("#new_affiliation_composite") do
          fill_in "affiliation_composite_country_autocomplete", with: "Polska"
          fill_in "affiliation_composite_institution_autocomplete", with: "Uniwersytet Jagielloński"
          fill_in "Rok od", with: "2014"
          fill_in "Rok do", with: "2016"
      end
        click_button 'Dodaj'

        expect(page).not_to have_content("Uniwersytet Jagielloński")
      end
      
    end
  end
end