require 'rails_helper'

feature "tytuly stron: " do

  context "anonimowy uzytkownik: " do
    scenario "czy strona public issues posiada tytuł numery rocznika" do
      visit '/public_issues'
      expect(page).to have_title 'Numery rocznika'
    end
  end

  context "po zalogowaniu: " do


    include_context "admin login"
    scenario "czy strona people posiada tytuł Osoby" do
      visit '/people'
      expect(page).to have_title 'Osoby'
    end
    scenario "czy strona people/new posiada tytuł Osoby" do
      visit '/people/new'
      expect(page).to have_title 'Osoby'
    end
    scenario "czy strona submissions posiada tytuł zgłoszone artykuły" do
      visit '/submissions'
      expect(page).to have_title 'Zgłoszone artykuły'
    end
    scenario "czy strona submissions/new posiada tytuł zgłoszone artykuly" do
      visit '/submissions/new'
      expect(page).to have_title 'Zgłoszone artykuły'
    end
    scenario "czy strona issues posiada tytuł numery rocznika" do
      visit '/issues'
      expect(page).to have_title 'Numery rocznika'
    end
    scenario "czy strona public issues posiada tytuł numery rocznika" do
      visit '/public_issues'
      expect(page).to have_title 'Numery rocznika'
    end
    scenario "czy strona reviews posiada tytuł recenzje" do
      visit '/reviews'
      expect(page).to have_title 'Recenzje'
    end
    scenario "czy strona articles posiada tytuł artykuł" do
      visit '/articles'
      expect(page).to have_title 'Artykuły'
    end

  end
end
