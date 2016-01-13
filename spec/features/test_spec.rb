require 'rails_helper'

feature "zarządzanie numerami" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "link do numerów rocznika" do
      visit '/people'
      click_link 'Numery rocznika'

      expect(page).to have_content("Numery rocznika")
    end
  end
end
