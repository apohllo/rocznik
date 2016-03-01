require 'rails_helper'

feature "publiczne dodawanie nowej wersji" do

   context "użytkownik dodaje nową wersję" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                   "mężczyzna", roles: ['autor'])
        Submission.create!(person_id: Person.first, status: "nadesłany", polish_title: "Ulisses",
                           received: '29-02-2016', english_title: "Ulisses", english_abstract: "A tale of a man", english_keywords: "ulisses", language: "polski", issue: Issue.first)
      end

      scenario "Dodawanie nowej wersji" do
        visit '/submissions/'
        click_on("Ulisses")
        click_on("Dodaj wersję")

        fill_in "Liczba stron", with: '3'
        fill_in "Liczba ilustracji", with: '5'
        attach_file("Artykuł", 'spec/features/files/plik.pdf')
        click_button 'Dodaj'

        within("#version") do
          expect(page).to have_content("plik.pdf")
          expect(page).to have_css("a[title='Edytuj komentarz']")
        end
      end

      scenario "Dodawanie nowej wersji bez pliku" do
        visit '/submissions/'
        click_on("Ulisses")
        click_on("Dodaj wersję")

        fill_in "Liczba stron", with: '3'
        fill_in "Liczba ilustracji", with: '5'
        click_button 'Dodaj'

        within("#new_article_revision") do
          expect(page).to have_css('.has-error')
        end
      end
    end
end

