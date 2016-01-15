require 'rails_helper'

feature "zarządzanie zgloszeniami" do
  scenario "sprawdzenie dostępności linka" do
    visit '/'
    expect(page).to have_content '/submissions'
  end

  scenario "sprawdzenie możliwości dodania nowego zgłoszenia" do
    visit '/submissions'
    expect(page).to have_content '/submissions'
  end

end
