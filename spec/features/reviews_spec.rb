require 'rails_helper'

feature "recenzowanie" do
  context "po zalogowaniu" do
    include_context "admin login"

    context "recenzja w bazie" do
      before do
        person1 = Person.create!(name:"Andrzej", surname:"Kapusta", discipline:"filozofia", email: "a.kapusta@gmail.com", roles: ['redaktor'])
        person2 = Person.create!(name:"Anna", surname:"Genialna", discipline:"filozofia", email: "a.genialna@gmail.com", roles: ['recenzent']),
        submission = Submission.create!(polish_title: "Dlaczego solipsyzm jest odpowiedzią na wszystkie pytania kognitywistyki?", language: "polski", received: "18-01-2016", status: "nadesłany", person: person1)
        article_revision = ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5", submission: submission)
        Review.create!(id: "1", status: "wysłane zapytanie", content: " ", asked: "18-01-2016", deadline: "10-12-2016", person: person1, article_revision: article_revision)
      end

      scenario "sprawdzanie możliwości edytowania recenzji" do
        visit '/reviews/1'
        expect(page).to have_css(".btn", text:"Edytuj")
      end
    end
  end
end
