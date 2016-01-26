require 'rails_helper'

feature "zarządzanie recenzjami" do
  
  context "po zalogowaniu" do
    include_context "admin login"
    
    context "Z recenzentem, autorem i tekstem w bazie danych" do

      before do
        author = Person.create!(name: "Dominika", surname: "Skoczeń", email: "d@o2.pl", discipline: "informatyka", sex: "kobieta")
        editor = Person.create!(name: "Piotr", surname: "Szysz", email: "p@o2.pl", discipline: "matematyka", sex: "mężczyzna")
        reviewer = Person.create!(name: "Anna", surname: "Salceson", email: "a@o2.pl", discipline: "polonistyka", sex: "kobieta", roles: ["recenzent"])
        country = Country.create!(name: "Polska")
        uj = Institution.create!(name: "Uniwersytet Jagielloński", country: country)
        pw = Institution.create!(name: "Politechnika Wrocławska", country: country)
        wydzial_matematyki = Department.create!(name: "Wydział Matematyki", institution: uj)
        wydzial_polonistyki = Department.create!(name: "Wydział Polonistyki", institution: pw)
        author_affiliation = Affiliation.create!(person: author, department: wydzial_matematyki, year_from: "2010", year_to: "2016")
        reviewer_affiliation = Affiliation.create!(person: reviewer, department: wydzial_polonistyki, year_from: "2011", year_to: "2016")
        submission1 = Submission.create!(polish_title: "Wielki Bęben", person: editor, status: "nadesłany", language: "polski", received: "02-01-2016")
        ArticleRevision.create!(submission: submission1, version: "1", pages: "3", pictures: "0")
        Authorship.create!(person: author, submission: submission1, corresponding: "true", position: "0")
      end
   
      scenario "Dodawanie recenzji" do
        visit '/submissions'
        
        click_link("Wielki Bęben")
        click_link 'Dodaj recenzenta'
        within("#new_review") do
            select "Salceson, Anna,", from: "Recenzent"
            select "wysłane zapytanie", from: "Status"
            fill_in "Zapytanie wysłano", with: "01-01-2016"
            fill_in "Deadline", with: "05-03-2016"
            fill_in "Uwagi", with: "Bardzo mądra uwaga"
          end
        click_button 'Dodaj'
        expect(page).to have_content("Anna Salceson")
      end
    
      scenario "Dodawanie recenzenta o innej afiliacji niż autor" do
        visit '/submissions'
        
        click_link("Wielki Bęben")
        click_link 'Dodaj recenzenta'
        within("#new_review") do
            select "Salceson, Anna,", from: "Recenzent"
            select "wysłane zapytanie", from: "Status"
            fill_in "Zapytanie wysłano", with: "01/01/2016"
            fill_in "Deadline", with: "05/03/2016"
            fill_in "Uwagi", with: "Bardzo mądra uwaga"
          end
        click_button 'Dodaj'
        expect(page).not_to have_css(".has-error")
      end
    end
  end
end
