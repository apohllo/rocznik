require "rails_helper"
require "capybara/email/rspec"

feature "Powiadamianie o nowym zgłoszeniu artykułu" do
  let(:email1) { 'em1@test.pl' }
  let(:email2) { 'em2@test.pl' }

  background do
    Person.create!(name: "Joanna", surname: "Gąska", email: email1, sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
    Person.create!(name: "Joanna", surname: "Gąska", email: email2, sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
  end

  scenario "zapytanie o sporządzenie recenzji" do
    clear_emails
    Submission.create!(status: "przyjęty", language: "polski", issue: Issue.first, person: Person.first, received: "19-01-2015", polish_title: "Alicja w krainie czarów", english_title: "Alice in Wonderland", english_abstract: "Little about that story", english_keywords: "Alice")

    open_email(email1)
    expect(current_email).to have_content 'Dodano nowe zgłoszenie'

    open_email(email2)
    expect(current_email).to have_content 'Dodano nowe zgłoszenie'
  end
end
