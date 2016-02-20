require "rails_helper"
require "capybara/email/rspec"

feature "Zapytanie" do

  context "po zalogowaniu" do
    include_context "admin login"

    background do
      Person.create!(name: "Joanna", surmame: "Gąska", email: "sz4n14@gmail.com", sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
      Issue.create!(volume: 20, year: 2002)
      Submission.create!(status: "przyjęty", language: "polski", issue: Issue.first, person: Person.first, received: "19-01-2015", polish_title: "Alicja w krainie czarów", english_title: "Alice in Wonderland", english_abstaract: "Little about that story", english_keywords: "Alice")
      ArticleRevision.create!(version: "1.0", received: "21-01-2016", pages: "10", submission: Submission.first)
      Review.create!(Article_revision: ArticleRevision.first, person: Person.first, status: "wysłane zapytanie", asked: '18-02-2016', deadline: '03-04-2016')
    end

    scenario "zapytanie o sporządzenie recenzji" do
      clear_emails
      visit '/submissions'
      click_link 'Alicja w krainie czarów'
      click_link 'Wyślij zapytanie o sporządzenie recenzji'
      open_email('sz4n14@gmail.com')
      expect(current_email).to have_content 'Gąska'
      expect(current_email).to have_content 'Alicja w krainie czarów'
      expect(current_email).to have_content 'Little about that story'
    end
  end
end