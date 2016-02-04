require 'rails_helper'

feature "zarządzanie osobami" do
  let(:email)         { "user@localhost.com" }
  let(:real_password) { "pass1234" }
  let(:password)      { real_password }

  before :each do
    User.create(email: email, password: real_password)

    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Adres e-mail', with: email
      fill_in 'Hasło', with: password
    end
    click_button 'Zaloguj się'
  end

  context "dobre hasło" do
    scenario "logowanie z poprawnymi danymi" do
      expect(page).to have_content 'pomyślnie'
    end
  end

  context "złe hasło" do
    let(:password)    { "wrong password" }

    scenario "logowanie z niepoprawnymi danymi" do
      expect(page).to have_content 'Zaloguj'
    end
  end
end
