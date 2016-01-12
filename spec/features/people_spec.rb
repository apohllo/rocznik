require 'rails_helper'

feature "zarządzanie osobami" do
  scenario "zarządzanie osobami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "link do nowej osoby" do
      visit '/people'
      click_link 'Nowa osoba'

      expect(page).to have_css("#new_person input[value='Utwórz']")
    end

    scenario "tworzenie nowej osoby" do
      visit '/people/new'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
        fill_in "Nazwisko", with: "Kapusta"
        fill_in "E-mail", with: "a.kapusta@gmail.com"
        fill_in "Dyscyplina", with: "filozofia"
        check "recenzent"
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Andrzej")
      expect(page).to have_content("Kapusta")
      expect(page).to have_content("a.kapusta@gmail.com")
    end

    scenario "tworzenie nowej osoby z brakującymi elementami" do
      visit '/people/new'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
      end
      click_button 'Utwórz'

      expect(page).to have_css(".has-error")
    end

    context "z jedną osobą w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia")
      end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kapusta")

        expect(page).to have_css("h3", text: "Andrzej Kapusta")
      end
    end

    context "z dwoma osobami w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia")
        Person.create!(name: "Wanda", surname: "Kalafior", email: "w.kalafior@gmail.com", discipline: "psychologia")
      end

      scenario "wyszukanie osoby" do
        visit "/people"
        fill_in "Nazwisko", with: "Kalafior"
        click_button("Szukaj")

        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrzej")
      end
    end
  end
end
