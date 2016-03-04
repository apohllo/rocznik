require "rails_helper"
require "capybara/email/rspec"

feature "Wysłanie maila informującego recenzenta o pojawieniu się nowej wersji artykułu" do

  context "po zalogowaniu" do
    include_context "admin login"

      before :each do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex: "mężczyzna", roles: ['recenzent'])
        Person.create!(name: "Anna", surname: "Genialna", email: "user@localhost.com", sex: "kobieta", roles: ['autor'], discipline:["psychologia"])
        Submission.create!(person: Person.last, status: "nadesłany", polish_title: "Ulisses", received: '29-02-2016', english_title: "Ulisses", english_abstract: "A tale of a man", english_keywords: "ulisses", language: "polski")
        Authorship.create!(person: Person.last, submission: Submission.last, corresponding: true, position: 1, signed: true)
      end

    scenario "sprawdzenie wysłania maila potwierdzającego przyjęcie zgłoszonego tekstu" do
     clear_emails
     visit '/user_submissions'
     click_link("Ulisses")

     click_link("Dodaj nową wersję")
     fill_in "Ilość stron", with: '3'
     fill_in "Ilość ilustracji", with: '5'
     attach_file("Plik", 'spec/features/files/plik.pdf')
     click_button 'Wyślij'

     open_email('a.kapusa@gmail.com')
     expect(current_email).to have_content 'pojawiła się nowa wersja artykułu'
     end
  end
end
