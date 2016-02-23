require 'rails_helper'

feature "zgloszenia" do

  context "po zalogowaniu" do
    include_context "user login"
    
    before :each do
        Submission.create!(person: Person.first, status: "odrzucony", polish_title: "Alicja w krainie czarów",
                             english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                             english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
    end
    
    scenario "wyświetlanie zgłoszeń dla autora korespondującego" do
      visit '/submissions'
        
      expect(page).to have_text("Zgłoszone artykuły")
    end
    
    scenario "wyświetlanie szczegółów zgłoszenia" do
        visit '/submissions'
        click_on("Alicja w krainie czarów")
        
        expect(page).to have_content("Little about that story")
    end
  end
end