require "rails_helper"
require "capybara/email/rspec"

feature "Powiadamianie o dodaniu nowej recenzji" do
  let(:email1) { 'em1@test.pl' }
  let(:email2) { 'em2@test.pl' }

  background do
    Person.create!(name: "Joanna", surname: "Gąska", email: email1, sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
    Person.create!(name: "Anna", surname: "Gąska", email: email2, sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
    Submission.create!(person: Person.first, status: "przyjęty", polish_title: "Alicja w krainie czarów",
                         english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                         english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
      article_file = Rails.root.join("spec/features/files/plik.pdf").open
      ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5",
                              article: article_file, submission: Submission.first)
end

 scenario "dodanie nowej recenzji" do
    clear_emails
    visit '/public_reviews/new'

      within("#new_review") do
        select "Alicja w krainie czarów", from: "Artykuł (wersja)" 
        select "Gąska, Joanna,", from: "Recenzent"
        fill_in "Zapytanie wysłano", with: "01-01-2001"
        fill_in "Deadline", with: "14-02-2001"
        fill_in "Uwagi", with: "XXX"
        fill_in "Treść recenzji", with: "XYZ"
      end
      click_button 'Dodaj'

    open_email(email1)
    expect(current_email).to have_content 'Dodano nową recenzję'

    open_email(email2)
    expect(current_email).to have_content 'Dodano nową recenzję'
  end
end