require "rails_helper"
require "capybara/email/rspec"

feature "Wysłanie maila potwierdzającego przyjęcie zgłoszenia" do

  context "zgłoszenie w bazie" do
    include_context "admin login"

    background do
      Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex: "mężczyzna", roles: ['autor'])
      Submission.create!(person: Person.first, status: "nadesłany", polish_title: "Artykuł o kotach", english_title: "Story about cats", english_abstract: "Cats are so amazing", english_keywords: "cats", received: "02-03-2016", language: "polski")
    end

    scenario "sprawdzenie wysłania maila potwierdzającego przyjęcie zgłoszonego tekstu" do
     clear_emails
     visit '/submissions'
     click_link 'Polski tytuł'
     click_link 'Edytuj'
     select "nadesłany", from: "Status"
     click_on 'Zapisz'
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
