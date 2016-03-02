require 'rails_helper'

feature "publiczne dodawanie nowej wersji" do

   context "użytkownik dodaje nową wersję" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                   "mężczyzna", roles: ['autor'])
        Submission.create!(person_id: Person.first, status: "nadesłany", polish_title: "Ulisses",
                           received: '29-02-2016', english_title: "Ulisses", english_abstract: "A tale of a man", english_keywords: "ulisses", language: "polski")
      end

      scenario "Dodawanie nowej wersji" do
        visit '/submissions'
        click_link("Ulisses")

        click_link("Dodaj nową wersję")

 	    fill_in "Otrzymano", with: "16/07/2016"
        fill_in "Liczba stron", with: '3'
        fill_in "Liczba ilustracji", with: '5'
        attach_file("Plik", 'spec/features/files/plik.pdf')
        click_button 'Zapisz'

        within("#version") do
        expect(page).to have_content("plik.pdf")
	    expect(page).to have_content("1-03-2016")
        expect(page).to have_css("a[title='Edytuj komentarz']")
        end
      end

      scenario "Dodawanie nowej wersji bez pliku" do
        visit '/submissions'

        click_link("Ulisses")
        click_link("Dodaj wersję")

	    fill_in "Otrzymano", with: "16/07/2016"
        fill_in "Liczba stron", with: '3'
        fill_in "Liczba ilustracji", with: '5'
        click_button 'Zapisz'

        within("#new_article_revision") do
	    expect(page).to have_content("1-03-2016")
        expect(page).to have_css('.has-error')
        end
      end

    end
end

