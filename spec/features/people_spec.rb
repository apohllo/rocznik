require 'rails_helper'

feature "zarządzanie osobami" do
  scenario "zarządzanie osobami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Zaloguj się'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "link do nowej osoby" do
      visit '/people'
      click_link 'Nowa osoba'

      expect(page).to have_css("#new_person input[value='Utwórz']")
    end

    scenario "layout dla administratora" do
      visit "/people"
      expect(page).not_to have_css("#sidebar")

      visit "/public_issues"
      expect(page).to have_css("#sidebar")
    end

    scenario "tworzenie nowej osoby" do
      visit '/people/new'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
        fill_in "Nazwisko", with: "Kapusta"
        fill_in "E-mail", with: "a.kapusta@gmail.com"
        check "filozofia"
        fill_in "Kompetencje", with: "Arystoteles"
        select "mężczyzna", from: "Płeć", visible: false
        check "recenzent"
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Andrzej")
      expect(page).to have_content("Kapusta")
      expect(page).to have_content("a.kapusta@gmail.com")
      expect(page).to have_content("Arystoteles")
      expect(page).to have_content("filozofia")
      expect(page).to have_css("img[src*='person']")
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
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com",
                      sex: "mężczyzna")
      end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kapusta")
        expect(page).to have_css("h3", text: "Andrzej Kapusta")
        expect(page).to have_css("dd", text: "mężczyzna")
      end

      scenario "dodanie zdjęcia" do
        visit '/people'
        click_on 'Kapusta'
        click_on 'Edytuj'

        attach_file("Zdjęcie", 'spec/features/files/man.png')
        click_button 'Zapisz'

        expect(page).to have_css("img[src*='man.png']")
      end

      scenario "wysłanie wiadomości do osoby" do
            visit '/people'
            click_on 'Kapusta'
            click_on 'Napisz wiadomość'
            expect(page).to have_css("h3", text: "Nowa wiadomość do a.kapusta@gmail.com")
            fill_in 'Tytuł', with: 'Pierwszy mail'
            fill_in 'Treść', with: 'Szanowny Panie, wysyłam swojego pierwszego maila. Z poważaniem, A.D.'
            click_on 'Wyślij'
            expect(current_email).to have_content 'Pierwszy mail'
            expect(current_email).to have_content 'Szanowny Panie, wysyłam swojego pierwszego maila. Z poważaniem, A.D.'
      end
    end

    context "z dwoma osobami w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com",
                       competence: "Arystoteles", sex: "mężczyzna", roles: ["redaktor"], discipline: ["filozofia"])
        Person.create!(name: "Wanda", surname: "Kalafior", email: "w.kalafior@gmail.com",
                       competence: "percepcja dźwięki", sex: "kobieta", roles: ["autor", "redaktor"], discipline: ["etyka"])
      end

      scenario "wyszukanie osoby" do
        visit "/people"
        fill_in "Nazwisko", with: "Kalafior"
        click_on("Filtruj")

        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrzej")
      end

      scenario "filtrowanie osob po roli" do
        visit "/people"
        select "autor", from: "Rola"
        click_on("Filtruj")

        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrzej")
      end
      
      scenario "filtrowanie osob po roli" do
        visit "/people"
        select "filozofia", from: "Dyscypliny"
        click_on("Filtruj")

        expect(page).to have_content("Andrzej")
        expect(page).not_to have_content("Wanda")
      end
      
      before do
          Issue.create!(volume: 3, year: 2020)
      end
      
       xscenario "reset filtrów i formularza" do
        visit "/people"
        fill_in "Nazwisko", with: "Kalafior"
        expect(page).to have_xpath("//input[@value='Kalafior']")
        click_button 'x'
        find_field('Nazwisko').value.blank?
        select "autor", from: "Rola"
        click_button 'Filtruj'
        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrzej")
        click_button 'x'
        expect(page).to have_content("Wanda")
        expect(page).to have_content("Andrzej")
      end
      
      scenario "przy usuwaniu zgłoszenia powinno być pytanie, czy użytkownik chce usunąć dane zgłoszenie" do
        visit "/people"
        click_on 'Kalafior'
        click_on 'Dodaj zgłoszenie'
        
        within("#new_submission") do
          fill_in "Tytuł", with: "Testowy tytuł zgłoszenia"
          fill_in "Title", with: "English title"
          fill_in "Abstract", with: "abc"
          fill_in "Key words", with: "def"
          fill_in "Otrzymano", with: "19/2/2016"
          select "Andrzej Kapusta", from: "Redaktor"
        end
        click_button("Utwórz")
        
        visit "/people"
        click_on 'Kalafior'
        page.find(".btn-danger").click 
        expect(page).to have_content("Zapytanie")
      end
      
    end
    context "określony status i nieokreślony status" do
      before do
        Person.create!(name: "Aleksandra", surname: "Hol", email: "alka.hol@onet.com",
                      sex: "kobieta", roles: ["recenzent"])
        Person.create!(name: "Anna", surname: "Kawiarka", email: "annakawi@rka.pl",
                      sex: "kobieta", roles: ["recenzent"], reviewer_status: "Recenzuje w terminie")
      end
      
      scenario "wyświetlenie statusu recenzenta" do
        visit "/people"
        click_on 'Hol'
        expect(page).not_to have_content("Status recenzenta")
        
        visit "/people"
        click_on 'Kawiarka'
        expect(page).to have_content("Status recenzenta")    
      end

      scenario "zmiana statusu recenzenta" do
        visit "/people"
        click_on 'Hol'
        click_on 'Edytuj'
        select "Recenzuje po terminie", from: "Status recenzenta"
        click_on 'Zapisz'
        expect(page).to have_content("Recenzuje po terminie")
      end
    end
  end
end
