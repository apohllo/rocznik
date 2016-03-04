require "rails_helper"
require "capybara/email/rspec"

feature "Wysłanie maila potwierdzającego przyjęcie zgłoszenia" do

  context "zgłoszenie w bazie" do
    include_context "admin login"

    background do
      Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex: "mężczyzna", roles: ['autor'])
      Person.create!(name: "Anna", surname: "Genialna", email: "user@localhost.com", sex:
                     "kobieta", roles: ['autor'], discipline:["psychologia"])
      Authorship.create!(person: Person.last, submission: Submission.first, corresponding: true, position: 1)
    end

    scenario "sprawdzenie wysłania maila potwierdzającego przyjęcie zgłoszonego tekstu" do
     clear_emails
     visit '/people'
     click_link "Kapusta"
     click_link 'Dodaj zgłoszenie'
     fill_in "Tytuł", with: "Artykuł o kotach"
     fill_in "Title", with: "Story about cats"
     fill_in "Abstract", with: "Cats are so amazing"
     fill_in "Key words", with: "cats"
     click_on 'Utwórz'
     expect(page).not_to have_css(".has-error")
     open_email('a.kapusa@gmail.com')
     expect(current_email).to have_content 'zostało przyjęte do systemu'
    end
  end
end



feature "Wysłanie maila informującego o zmianie recenzji" do

  context "po zalogowaniu" do
    include_context "admin login"

    background do
      Person.create!(name: "Anna", surname: "Kowalska", email: "kowal76767@gmail.com",
                     sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
      Issue.create!(volume: 333, year: 2333)
      Submission.create!(status: "przyjęty", language: "polski", issue: Issue.first,
                         person: Person.first, received: "19-02-2015",
                         polish_title: "Polski tytuł",
                         english_title: "English title",
                         english_abstract: "Abstract", english_keywords: "title")
    end

    scenario "sprawdzenie wysłania statusu odrzuconego w treści maila" do
      clear_emails
      visit '/submissions'
      click_link 'Polski tytuł'
      click_link 'Edytuj'
      select "odrzucony", from: "Status"
      click_on 'Zapisz'
      open_email('kowal76767@gmail.com')
      expect(current_email).to have_content 'odrzucony'
    end
  end
end
