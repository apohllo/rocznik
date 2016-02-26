require 'rails_helper'

feature "zgloszenia" do

  context "po zalogowaniu" do
    include_context "user login"
    
    before :each do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                       "mężczyzna", roles: ['redaktor'], discipline:["psychologia"])
        Person.create!(name: "Anna", surname: "Genialna", email: "user@localhost.com", sex:
                       "kobieta", roles: ['autor'], discipline:["psychologia"])
        Submission.create!(person: Person.first, status: "odrzucony", polish_title: "Alicja w krainie czarów",
                             english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                             english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
        Authorship.create!(person: Person.last, submission: Submission.first, corresponding: true, position: 1)
    end
    
    scenario "wyświetlanie zgłoszeń dla autora korespondującego" do
      visit '/user_submissions'
        
      expect(page).to have_text("Zgłoszone artykuły")
    end
    
    scenario "wyświetlanie szczegółów zgłoszenia" do
        visit '/user_submissions'
        click_on("Alicja w krainie czarów")
        
        expect(page).to have_content("Little about that story")
    end
  end
end