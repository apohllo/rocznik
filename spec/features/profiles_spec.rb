require 'rails_helper'

feature "zarządzanie profilem użytkownika" do
  context "po zalogowaniu" do
    context "profil użykownika w bazie" do
      before do
        Person.create!(name: "Anna", surname: "Genialna", email: "a.genialna@gmail.com",
                      sex: "kobieta")
      end
      scenario "sprawdzanie możliwości edycji profilu" do
        visit '/profile'
      
        expect(page).to have_css('a[title="Edytuj swoje dane"]')
        expect(page).to have_css('a[title="Edytuj hasło"]')
      end
    
      scenario "edytowanie profilu użytkownika" do
        visit '/profile'
        click_on("Edytuj swoje dane")
        fill_in "Stopień", with: "Profesor"
        fill_in "Imię", with: "Anna"
        fill_in "Nazwisko", with: "Nowicka"
        click_on("Zapisz")
      
        expect(page).to have_content("Anna Nowicka")
        expect(page).not_to have_css(".has-error")
        expect(page).to have_css(".accepted")
      end
    end
    
    let(:email)                 { "user@localhost.com" }
    let(:current_password)      { "pass1234" }
    let(:password)              { "passwd1234" }
    let(:password_confirmation) { password }
  
    context "poprawne hasło" do
      scenario "edycja hasła z poprawnym aktualnym hasłem" do
        visit '/profile'
        click_on("Edytuj hasło")
        fill_in "Aktualne hasło", with: current_password
        fill_in "Nowe hasło", with: password
        fill_in "Powtórz nowe hasło", with: password_confirmation
        click_on("Zapisz")
        
        visit '/users/sign_in'
        within("#new_user") do
          fill_in 'Adres e-mail', with: email
          fill_in 'Hasło', with: password
        end
        click_button 'Zaloguj się'
        
        expect(page).to have_content("Anna Nowicka")
        expect(page).not_to have_css(".has-error")
        expect(page).to have_css(".accepted")
      end
    end
  
    context "błędne hasło" do
      let(:current_password)    { "wrong password" }
  
      scenario "edycja hasła z niepoprawnym hasłem aktualnym" do
        visit '/profile'
        click_on("Edytuj hasło")
        fill_in "Aktualne hasło", with: current_password
        fill_in "Nowe hasło", with: password
        fill_in "Powtórz nowe hasło", with: password_confirmation
        click_on("Zapisz")
      
        expect(page).to have_css(".has-error")
      end
    end
  end
end