require 'rails_helper'

feature "zarządzanie recenzjami" do
  
  context "po zalogowaniu" do
    include_context "admin login"
    
    context "Z recenzentem, autorem i tekstem w bazie danych" do
		
		before do

			Submission.create!(polish_title: "Wielki Bęben", person_id: "1", status: )

		end
		
		scenario "Dodawanie recenzji przez stronę Zgłoszone Artykuły" do
		  visit '/reviews/new?submission_id=1'

		  within("#new_review") do
			select "Jeziorski, Marek", from: "Recenzent"
			select "wysłane zapytanie", from: "Status"
			select "18-01-2016", from: "Zapytanie wysłano"
			select "03-03-2016", from: "Deadline"
			fill_in "Uwagi", with: ""
		  end
		  click_button 'Dodaj'

		  expect(page).to have_css(".has-error")
		end
	end
  end
end
