require 'rails_helper'

feature "publiczne dodawanie zgloszenia" do

  scenario "użycie linku w menu bocznym" do
    visit '/'
    click_on('Zgłoś artykuł')

    expect(page).to have_text("Nowe zgłoszenie")
    expect(page).to have_button("Dalej")
  end

end
