require 'rails_helper'

feature "zarządzanie profilem użytkownika" do
  let(:email)           { "user@localhost.com" }
  let(:real_password)   { "pass1234" }
  let(:password)        { real_password }
  context "po zalogowaniu" do
    before :each do
      Person.create!(name: "Anna", surname: "Genialna", email: email,
                      sex: "kobieta")
      User.create!(email: email, password: real_password, password_confirmation: real_password)
  
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Adres e-mail', with: email
        fill_in 'Hasło', with: password
      end
      click_button 'Zaloguj się'
      
      expect(page).to have_content 'pomyślnie'
      
    end
    
    scenario "edytowanie profilu użytkownika" do
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Adres e-mail', with: email
        fill_in 'Hasło', with: password
      end
      click_button 'Zaloguj się'
      
      expect(page).to have_content 'pomyślnie'
      
        visit '/profile'
        click_on("Edytuj swoje dane")
        fill_in "Stopień", with: "Profesor"
        fill_in "Imię", with: "Anna"
        fill_in "Nazwisko", with: "Nowicka"
        click_on("Zapisz")
        
        expect(page).not_to have_css(".has-error")
        expect(page).to have_text("Profesor")
      end
    
    let(:new_password)          { "passwd1234" }
    let(:password_confirmation) { new_password }
  
      context "poprawne hasło" do
        scenario "edycja hasła z poprawnym aktualnym hasłem" do
          visit '/profile'
          click_on("Edytuj hasło")
          fill_in "Aktualne hasło", with: password
          fill_in "Nowe hasło", with: new_password
          fill_in "Powtórz nowe hasło", with: password_confirmation
          click_on("Zapisz")
          
          click_on "Wyloguj"
          visit '/users/sign_in'
          within("#new_user") do
            fill_in 'Adres e-mail', with: email
            fill_in 'Hasło', with: new_password
          end
          click_button 'Zaloguj się'
          
          expect(page).to have_content 'pomyślnie'
        end
      end
    
      context "błędne hasło" do
        let(:wrong_password)      { "wrong_password" }
        
        scenario "edycja hasła z niepoprawnym hasłem aktualnym" do
          visit '/profile'
          click_on("Edytuj hasło")
          fill_in "Aktualne hasło", with: wrong_password
          fill_in "Nowe hasło", with: new_password
          fill_in "Powtórz nowe hasło", with: password_confirmation
          click_on("Zapisz")
        
          expect(page).to have_css(".has-error")
        end
      end
  end
end
    