require 'rails_helper'

feature "Nowy formularz rejestracji pozwalający na podanie danych osobowych" do

  scenario "Tworzenie nowego użytkownika" do
    visit '/users/sign_up'

    within("#new_user") do
      fill_in "Adres e-mail", with: "andrzej.kapusta@gmail.com"
      fill_in "Hasło", with: "asdfasdf"
      fill_in "Potwierdzenie hasła", with: "asdfasdf"
    end
    click_button 'Zarejestruj się'

      expect(page).to have_content 'Podaj dane'
  end
 

  scenario "Dodanie danych osobowych" do
    visit '/users/new_person'

    within("#new_person") do
      fill_in "Imię", with: "Andrzej"
      fill_in "Nazwisko", with: "Kapusta"
	  select "mężczyzna", from: "Płeć", visible: false
    end
    click_button 'Zarejestruj się'
  end
end
