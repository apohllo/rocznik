require 'rails_helper'

feature "zgloszenia" do

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "sprawdzenie czy jest odnosnik prowadzacy do zgloszen w menu" do
      visit '/issues/'
      click_on('Zgłoszone artykuły')

		expect(page).to have_css(".btn", text: "Nowe zgłoszenie")
    end
	
    scenario "sprawdzenie czy przenosi do strony submission/new" do
      visit '/submissions/'
      click_on('Nowe zgłoszenie')
      
      expect(page).to have_css(".form-group")
    end

    context "redaktor w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta",
                       discipline: "filozofia",
                       email: "a.kapusa@gmail.com", roles: ['redaktor'])
      end

      scenario "tworzenie nowego zgloszenia" do
        visit '/submissions/new/'
        within("#new_submission") do
          fill_in "Tytuł", with: "Testowy tytuł zgłoszenia"
          fill_in "Streszczenie", with: "Testowe streszczenie"
          fill_in "Słowa kluczowe", with: "kluczowe kluczeowe slowa"
          fill_in "Title", with: "English title"
          fill_in "Abstract", with: "absbabsba"
          fill_in "Key words", with: "englsh key words"
          select "Andrzej Kapusta", from: "Redaktor"
        end
        click_button("Utwórz")
    
        expect(page).not_to have_css(".has-error")
        expect(page).to have_content("Testowy tytuł zgłoszenia")
      end
    end
  end
end

