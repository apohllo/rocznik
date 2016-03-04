require 'rails_helper'

feature "publiczne dodawanie nowej wersji" do

  context "po zalogowaniu" do
      include_context "user login"

      before :each do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex: "mężczyzna", roles: ['autor'])
        Person.create!(name: "Anna", surname: "Genialna", email: "user@localhost.com", sex: "kobieta", roles: ['autor'], discipline:["psychologia"])
        Submission.create!(person: Person.last, status: "nadesłany", polish_title: "Ulisses", received: '29-02-2016', english_title: "Ulisses", english_abstract: "A tale of a man", english_keywords: "ulisses", language: "polski")
        Authorship.create!(person: Person.last, submission: Submission.last, corresponding: true, position: 1, signed: true)
      end

      scenario "Dodawanie nowej wersji" do
        visit '/user_submissions'
        click_link("Ulisses")

        click_link("Dodaj nową wersję")
        fill_in "Ilość stron", with: '3'
        fill_in "Ilość ilustracji", with: '5'
        attach_file("Plik", 'spec/features/files/plik.pdf')
        click_button 'Wyślij'
        expect(page).not_to have_css('.has-error')
        expect(page).to have_content("Ulisses")
      end

      scenario "Dodawanie nowej wersji bez pliku" do
        visit '/user_submissions'
        click_link("Ulisses")
        
        click_link("Dodaj nową wersję")
        fill_in "Ilość stron", with: '3'
        fill_in "Ilość ilustracji", with: '5'
        click_button 'Wyślij'

        expect(page).to have_css('.has-error')
      end
    end
end

