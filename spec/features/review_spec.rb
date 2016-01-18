require 'rails_helper'

feature "recenzowanie" do
  context "po zalogowaniu" do
    before do
      Person.create!(name:"Andrzej", surname:"Kapusta", discipline:"filozofia", email: "a.kapusta@gmail.com", roles: ['redaktor'])
      Person.create!(name:"Anna", surname:"Genialna", discipline:"filozofia", email: "a.genialna@gmail.com", roles: ['recenzent'])
      Submission.create!(status: "nadesłany", language: "polski", received: "18-01-2016", polish_title: "Dlaczego solipsyzm jest odpowiedzią na wszystkie pytania kognitywistyki?")
    end
    scenario "przypisanie recenzenta do zgłoszenia" do
      visit '/submissions/1'
      expect(page).to have_css(".btn", text:"Dodaj recenzenta")
    end
  end
end
