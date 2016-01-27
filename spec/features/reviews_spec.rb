require 'rails_helper'

feature "recenzowanie" do
  context "po zalogowaniu" do
    include_context "admin login"

    context "recenzja w bazie" do
      before do
        person_1 = Person.create!(name:"Andrzej", surname:"Kapusta", discipline:"filozofia", sex: "mężczyzna", email:
                                  "a.kapusta@gmail.com", roles: ['redaktor'])
        Person.create!(name:"Anna", surname:"Genialna", discipline:"filozofia", email: "a.genialna@gmail.com", sex:
                       "kobieta",roles: ['recenzent'])
        Person.create!(name:"Wojciech", surname:"Nowak", discipline:"fizyka", email: "w.nowak@gmail.com", sex:
                       "mężczyzna",roles: ['recenzent'])
        submission_1 =
          Submission.create!(language: "polski", received: "18-01-2016", status: "nadesłany", person: person_1,
                             polish_title: "Dlaczego solipsyzm?", english_title: "title1", english_abstract:
                             "abstract1", english_keywords: "tag1, tag2")
        article_revision_1 =
          ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5", submission: submission_1)
        submission_2 =
          Submission.create!(language: "polski", received: "18-01-2016", status: "nadesłany", person: person_1,
                             polish_title: "Arystoteles.", english_title: "title2", english_abstract: "abstract2",
                             english_keywords: "tag1, tag2")
        article_revision_2 =
          ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5", submission: submission_2)
        Review.create!(status: "wysłane zapytanie", content: " ", asked: "18-01-2016", deadline: "10-12-2016", person:
                       person_1, article_revision: article_revision_1)
        Review.create!(status: "recenzja negatywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_1, article_revision: article_revision_2)
      end

      scenario "sprawdzanie możliwości edytowania recenzji" do
        visit '/reviews'
        click_on('Dlaczego solipsyzm?, v. 1')
        expect(page).to have_css(".btn", text:"Edytuj")
      end

      scenario "edytowanie recenzji" do
        visit '/reviews'
        click_on('Dlaczego solipsyzm?, v. 1')
        click_on("Edytuj")
        fill_in "Treść recenzji", with: "Testowa recenzja"
        select "recenzja przyjęta", from: "Status"
        click_on("Zapisz")

        expect(page).to have_content("Testowa recenzja")
        expect(page).not_to have_css(".has-error")
        expect(page).to have_css(".accepted")
      end

      scenario "dodawanie recenzji dla recenzenta" do
        visit '/people'

        click_on 'Genialna'
        click_on 'Dodaj recenzję'
        select "Dlaczego solipsyzm?, v. 1", from: "Artykuł (wersja)"
        click_on 'Dodaj'

        expect(page).not_to have_css(".has-error")
        expect(page).to have_content(/Przypisane recenzje.*Dlaczego solipsyzm/)
      end

      scenario "dodawanie recenzji do zgłoszenia" do
        visit '/submissions'

        click_on 'Dlaczego solipsyzm?'
        click_on 'Dodaj recenzenta'
        select 'Nowak, Wojciech', from: "Recenzent"
        click_on 'Dodaj'

        expect(page).not_to have_css(".has-error")
        expect(page).to have_content(/Recenzje.*Wojciech Nowak/)
      end

      scenario "filtrowanie recenzji po statusie" do
        visit "/reviews"

        select "recenzja negatywna", from: "Status"
        click_on "Filtruj"

        expect(page).to have_content("16-01-2017")
        expect(page).not_to have_content("10-12-2016")
      end

      scenario "sortowanie recenzji wzgledem deadlinu" do
        visit "/reviews"
        expect(page).to have_content(/10-12-2016.*16-01-2017/)

        click_on "Deadline"
        expect(page).to have_content(/16-01-2017.*10-12-2016/)

        click_on "Deadline"
        expect(page).to have_content(/10-12-2016.*16-01-2017/)
      end
    end
  end
end
