require 'rails_helper'

feature "wersje" do

  context "po zalogowaniu" do
    include_context "admin login"


    context "redaktor, numer i zgłoszenie w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", discipline: "filozofia", email: "a.kapusa@gmail.com", sex:
                       "mężczyzna", roles: ['redaktor', 'recenzent'])
        Issue.create!(volume: 3, year: 2020)
        Submission.create!(person_id: Person.first, status: "nadesłany", polish_title: "Alicja w krainie czarów",
                           english_title: "Alice in Wonderland", english_abstract: "Little about that story",
                           english_keywords: "alice", received: "19-01-2016", language: "polski", issue: Issue.first)
      end

      scenario "Dodawanie nowej wersji" do
        visit '/submissions/'
        click_on("Alicja w krainie czarów")

        click_on("Dodaj wersję")

        fill_in "Otrzymano", with: "16/07/2016"
        fill_in "Liczba stron", with: '1'
        fill_in "Liczba ilustracji", with: '1'
        attach_file("Artykuł", 'spec/features/files/plik.pdf')
        click_button 'Dodaj'

        within("#version") do
          expect(page).to have_content("plik.pdf")
          expect(page).to have_content("16-07-2016")
          expect(page).to have_content("Edytuj")
        end
      end

      context "wersja w bazie" do
        before do
          ArticleRevision.create!(submission: Submission.first,
                                  pages: 1, pictures: 1, version: 1,
                                  comment: "Brakuje przecinka na 1 stronie w wierszu 30",
                                  accepted: '0')
        end

        scenario "Przyciski akcji dla wersji" do
          visit "/submissions/"
          click_on("Alicja w krainie czarów")
          within('#version') do
            expect(page).to have_content('Edytuj')
            expect(page).to have_content('Zobacz')
            expect(page).to have_css('.fa-trash-o')
          end
        end

        scenario "Edycja wersji" do
          visit "/submissions/"
          click_on("Alicja w krainie czarów")
          within("#version") do
            click_on("Edytuj")
          end

          fill_in "Komentarz", with: "Przecinka brakuje jednak w 31 wierszu"
          check "Zatwierdź"
          click_on("Zapisz")

          within("#version") do
            click_on("Zobacz")
          end

          expect(page).to have_content("Przecinka brakuje jednak w 31 wierszu")
          page.has_checked_field?("Zatwierdź")
        end
      end
    end
  end
end
