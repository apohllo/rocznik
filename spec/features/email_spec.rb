require 'rails_helper'
require 'capybara/email/rspec'

feature 'Emailer' do
  context "po zalogowaniu" do
    include_context "admin login"

    background do
      Person.create!(name: "Andrzej", surname: "Kapusta", discipline: ["filozofia"], email: "a.kapusa@gmail.com", sex:
                     "mężczyzna", roles: ['redaktor', 'recenzent','autor'])
      Person.create!(name: "Adam", surname: "Kapusta", discipline: ["filozofia"], email: "adam.kapusa@gmail.com", sex:
                     "mężczyzna", roles: ['redaktor', 'recenzent'])
      Issue.create!(volume: 31, year: 2021)
      Submission.create!(person: Person.first, status: "przyjęty", polish_title: "Alicja w krainie czarów",
                         english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                         english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
      article_file = Rails.root.join("spec/features/files/plik.pdf").open
      ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5",
                              article: article_file, submission: Submission.first)
      Review.create!(status: "wysłane zapytanie", content: " ", asked: "18-01-2016", deadline: "20-01-2016", person:
                     Person.last, article_revision: ArticleRevision.first)

      clear_emails
      visit '/submissions'
      click_link 'Alicja w krainie czarów'
      click_link 'Wyślij zapytanie o recenzję'

      open_email('adam.kapusa@gmail.com')
    end

    scenario 'sprawdzanie treści wiadomości' do
      expect(current_email).to have_content 'Szanowna Pani/ Szanowny Panie'
    end
  end
    scenario 'sprawdzenie dodania hasła' do
	clear_emails

	visit '/submission'
	clink_in 'Alicja w krainie czarów'
	click_in'Dodaj autora'
        select 'Kapusta, Andrzej', from: 'Autor'
	click_in'Dodaj'
	open_email('a.kapusa@gmail.com')
	expect(current_email).to have_content 'hasło'
	expect(current_email).to have_content 'a.kapusa'
  end
end
