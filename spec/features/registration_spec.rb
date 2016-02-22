require 'rails_helper'

feature "Nowy formularz rejestracji pozwalający na podanie danych osobowych" do

  scenario "Tworzenie nowego użytkownika" do
    visit '/users/sign_up'

    within("#new_user") do
      fill_in "email", with: "andrzej.kapusta@gmail.com"
    end
    click_button 'Zarejestruj się'
  end

  scenario "Dodanie danych osobowych" do
    visit '/users/new_person'

    within("#new_person") do
      fill_in "imię", with: "Andrzej"
      fill_in "nazwisko", with: "Kapusta"
	  select "mężczyzna", from: "płeć", visible: false
    end
    click_button 'Zarejestruj się'

    expect(page).to have_css(".has-error")
  end
end
