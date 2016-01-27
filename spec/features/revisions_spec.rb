require 'rails_helper'

feature "zarządzanie recenzjami" do

  context "po zalogowaniu" do
    include_context "admin login"

    context "Z recenzentem, autorem i tekstem w bazie danych" do

      before do
        author = Person.create!(name: "Dominika", surname: "Zujotu", email: "d@o2.pl", discipline: "informatyka", sex:
                                "kobieta", roles: ["autor"])
        editor = Person.create!(name: "Piotr", surname: "Zujotu", email: "p@o2.pl", discipline: "matematyka", sex:
                                "mężczyzna", roles: ["recenzent", "redaktor"])
        reviewer = Person.create!(name: "Anna", surname: "Zpolibudy", email: "a@o2.pl", discipline: "polonistyka", sex:
                                  "kobieta", roles: ["recenzent"])
        country = Country.create!(name: "Polska")
        uj = Institution.create!(name: "Uniwersytet Jagielloński", country: country)
        pw = Institution.create!(name: "Politechnika Wrocławska", country: country)
        math = Department.create!(name: "Wydział Matematyki", institution: uj)
        polish = Department.create!(name: "Wydział Polonistyki", institution: pw)
        Affiliation.create!(person: author, department: math)
        Affiliation.create!(person: reviewer, department: polish)
        Affiliation.create!(person: editor, department: math)
        submission = Submission.create!(polish_title: "Wielki Bęben", person: editor, status: "nadesłany", language:
                                        "polski", received: "02-01-2016", english_title: "Big Bum", english_abstract:
                                        "Big Bum abstract", english_keywords: "big, bum")
        ArticleRevision.create!(submission: submission, version: "1", pages: "3", pictures: "0")
        Authorship.create!(person: author, submission: submission, corresponding: "true", position: "0")
      end

      scenario "Dodawanie recenzenta o takiej samej afiliacji jak autor" do
        visit '/submissions'

        click_link("Wielki Bęben")
        click_link 'Dodaj recenzenta'
        within("#new_review") do
          select "Zujotu, Piotr", from: "Recenzent"
          select "wysłane zapytanie", from: "Status"
          fill_in "Zapytanie wysłano", with: "01/01/2016"
          fill_in "Deadline", with: "05/03/2016"
          fill_in "Uwagi", with: "Bardzo mądra uwaga"
        end
        click_button 'Dodaj'

        expect(page).to have_css(".has-error")
      end

      scenario "Dodawanie recenzenta o innej afiliacji niż autor" do
        visit '/submissions'

        click_link("Wielki Bęben")
        click_link 'Dodaj recenzenta'
        within("#new_review") do
          select "Zpolibudy, Anna,", from: "Recenzent"
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
