require 'rails_helper'

feature "Zarządzanie numerami" do
  scenario "-> Zarządzanie numerami bez uprawnień" do
    visit '/issues'

    expect(page).to have_content 'Zaloguj się'
  end

  context "-> Po zalogowaniu" do
    include_context "admin login"

    scenario "-> Dostępność numerów w menu" do
      visit '/people'

      expect(page).to have_link("Numery rocznika")
    end

    scenario "-> Wyświetlanie pustej listy numerów" do
      visit '/issues'

      expect(page).to have_css("h3", text: "Numery rocznika")
    end

    scenario "-> Link do nowego numeru" do
      visit '/issues'
      click_link 'Nowy numer'

      expect(page).to have_css("#new_issue input[value='Utwórz']")
    end

    scenario "-> Tworzenie nowego numeru" do
      visit '/issues/new'

      within("#new_issue") do
        fill_in "Numer", with: 2
        fill_in "Rok", with: 2017
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content(2)
      expect(page).to have_content(2017)
    end

    context "-> Podsumowanie numeru" do
      let(:author)                  { create(:author) }
      let(:issue)                   { create(:issue, volume: 1, year: 2008) }
      let(:water_article)           { create(:submission, status: "przyjęty", issue: issue, polish_title: "Artykuł o wodzie",
                                             english_keywords: "water", english_abstract: "Water is a fluid") }
      let(:air_article)             { create(:submission, status: "przyjęty", issue: issue, polish_title: "Artykuł o powietrzu",
                                             english_keywords: "air", english_abstract: "Air is a gas") }
      before do
        [water_article, air_article]
        issue.prepare_to_publish(issue.submissions.accepted.map(&:id))
      end

      scenario "-> Podsumowanie" do
        visit '/issues'
        click_on(issue.volume.to_s)
        click_on('Podsumowanie')

        expect(page).to have_content("Podsumowanie numeru 1/2008")
        expect(page).to have_content("Artykuł o wodzie")
        expect(page).to have_content("water")
        expect(page).to have_content("Water is a fluid")
        expect(page).to have_content("Artykuł o powietrzu")
        expect(page).to have_content("air")
        expect(page).to have_content("Air is a gas")
      end
    end

    context "-> Liczba i udział procentowy recenzentów z uczelni" do
      let(:author)                  { create(:author) }
      let(:rejected_author)         { create(:author) }
      let(:uj_reviewer_1)           { create(:reviewer)  }
      let(:uj_reviewer_2)           { create(:reviewer)  }
      let(:uj_reviewer_3)           { create(:reviewer)  }
      let(:mit_reviewer_1)          { create(:reviewer)  }
      let(:issue)                   { create(:issue, volume: 1, year: 2008) }
      let(:empty_issue)             { create(:issue, volume: 2, year: 2009) }
      let(:psychology_at_uj)        { create(:psychology_at_uj) }
      let(:psychology_at_mit)       { create(:psychology_at_mit) }
      let(:accepted_submission)     { create(:submission, status: "przyjęty", issue: issue) }
      let(:rejected_submission)     { create(:submission, status: "odrzucny", issue: issue) }
      let(:article_revision)        { create(:article_revision, submission: accepted_submission) }
      let(:uj_review_positive)      { create(:review, status: 'recenzja pozytywna', person: uj_reviewer_1,
                                             article_revision: article_revision) }
      let(:uj_review_negative)      { create(:review, status: 'recenzja negatywna', person: uj_reviewer_2,
                                             article_revision: article_revision) }
      let(:uj_review_rejected)      { create(:review, status: 'recenzja odrzucona', person: uj_reviewer_3,
                                             article_revision: article_revision) }
      let(:mit_review_positive)     { create(:review, status: 'recenzja pozytywna', person: mit_reviewer_1,
                                             article_revision: article_revision) }

      before do
        create(:affiliation, person: uj_reviewer_1, department: psychology_at_uj)
        create(:affiliation, person: uj_reviewer_2, department: psychology_at_uj)
        create(:affiliation, person: uj_reviewer_3, department: psychology_at_uj)
        create(:affiliation, person: mit_reviewer_1, department: psychology_at_mit)
        [issue, empty_issue, uj_review_positive, uj_review_negative, uj_review_rejected, mit_review_positive]
        issue.prepare_to_publish(issue.submissions.accepted.map(&:id))
        issue.publish
        empty_issue.prepare_to_publish(empty_issue.submissions.accepted.map(&:id))
        empty_issue.publish
      end

      scenario "-> 66% UJotu" do
        visit '/issues'
        click_on(issue.volume.to_s)
        click_on('Statystyki')

        expect(page).to have_content("Liczba recenzentów z Uniwersytetu Jagiellońskiego 2 3 66")
        expect(page).to have_content("Liczba recenzentów z innych uczelni 1 3 33")
      end

      scenario "-> Brak recenzentów" do
        visit '/issues'
        click_on(empty_issue.volume.to_s)
        click_on('Statystyki')

        expect(page).to have_content("Liczba recenzentów z Uniwersytetu Jagiellońskiego 0 0 0")
        expect(page).to have_content("Liczba recenzentów z innych uczelni 0 0 0")
      end

      scenario "-> 75% Polaków" do
        visit '/issues'
        click_on(issue.volume.to_s)
        click_on('Statystyki')

        expect(page).to have_content("Liczba recenzentów z Polski 2 3 66")
        expect(page).to have_content("Liczba recenzentów spoza Polski 1 3 33")
      end

      scenario "-> Brak afiliacji" do
        visit '/issues'
        click_on(empty_issue.volume.to_s)
        click_on('Statystyki')

        expect(page).to have_content("Liczba recenzentów z Polski 0 0 0")
        expect(page).to have_content("Liczba recenzentów spoza Polski 0 0 0")
      end
    end

    context "-> Dwa numery i jedno zgłoszenie" do
      before do
        Issue.create!(volume: 98, year: 2098)
        Issue.create!(volume: 99, year: 2099)
        Submission.create!(status:'przyjęty', language:"polski", issue:
                           Issue.last, polish_title: "proba",
                           english_title: "test", english_abstract:
                           "english", english_keywords: "test,
                             exam", received: "2015-01-17")

      end

      scenario "-> Sprawdzanie niedostepnosci linku" do
        visit '/issues/98-2098'

        expect(page).to have_css(".disabled")
      end

      scenario "-> Sprawdzanie dostepnosci linku" do
        visit '/issues/99-2099'

        expect(page).not_to have_css(".disabled")
      end

      scenario "-> Przygotowanie numeru do wydania" do
        visit '/issues/99-2099'
        click_link "Przygotuj do wydania"

        expect(page).to have_content("Przygotuj numer do wydania")
      end

      scenario "-> Wyswietlenie publikowanych artykulow" do
        visit '/issues/99-2099/prepare_form'
        click_button "Przygotuj numer do wydania"

        expect(page).to have_content("Publikowane artykuły")
      end
    end

    context "z jednym numerem w bazie danych" do
      before do
        Issue.create!(volume: 3, year: 2020)
      end

      scenario "wyświetlenie szczegółów numeru" do
        visit "/issues"
        click_link "3"

        expect(page).to have_content("Numer 3/2020")
        expect(page).to have_link("Przygotuj do wydania")
      end

      scenario "dostępność edycji numeru" do
        visit "/issues"
        click_link "3"

        expect(page).to have_link("Edytuj")
      end

      scenario "dodawanie zgłoszenia z istniejącym numerem i sprawdzenie zgłoszenia w numerze" do
        visit '/submissions/new'

        within("#new_submission") do
          select "nadesłany", from: "Status"
          select "polski", from: "Język"
          select "3/2020", from: "Numer"
          fill_in "Otrzymano", with: "12-01-2016"
          fill_in "Tytuł", with: "próbny tytuł"
          fill_in "Title", with: "trial"
          fill_in "Abstract", with: "trial abstract"
          fill_in "Key words", with: "trial key words"
        end
        click_button 'Utwórz'

        visit "/issues"
        click_link "3"

        expect(page).to have_content("próbny tytuł")
      end

      context "z jednym zaakceptowanym zgłoszeniem" do
        before do
          Submission.create!(status:'przyjęty', language:"polski", issue:
                             Issue.first, polish_title: "Zaakceptowany tytuł",
                             english_title: "Accepted title", english_abstract:
                             "Short abstract", english_keywords: "brain,
                             language", received: "2016-01-17")
        end

        xscenario "potwierdzenie usunięcia zgłoszenia w widoku numeru" do
          visit '/issues/'
          click_on '3'
		        page.find(".btn-danger").click
          expect(page).to have_content("Zapytanie")
        end

        scenario "Przygotowanie numeru do wydania" do
          visit "/issues"

          click_link "3"
          click_link "Przygotuj do wydania"
          expect(page).to have_content("Wybierz artykuły")

          check 'Zaakceptowany tytuł'
          click_button 'Przygotuj numer do wydania'
          expect(page).not_to have_css(".has-error")
          expect(page).not_to have_content("Wybierz artykuły do wydania")
        end

        context "z jedną recenzją" do
          before do
            Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                           "mężczyzna", roles: ['redaktor', 'recenzent'])
            article_file = Rails.root.join("spec/features/files/plik.pdf").open
            revision = ArticleRevision.create!(submission: Submission.first, received: '19-01-2016',
                                              pages: 1, pictures: 1, version: 1, article: article_file)
            Review.create!(article_revision: revision, deadline: '28/01/2016', person: Person.first,
                           status: "recenzja pozytywna", asked: '1/01/2016', content: "treść rezenzji")
          end

          scenario "dostępność przeglądu recenzji" do
            visit "/issues"

            click_link "3"
            expect(page).to have_link("Pokaż recenzje")
          end

          scenario "wyświetlenie tytułów artykułów oraz treści rezenzji" do
            visit "/issues"

            click_link "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Pokaż recenzje"
            expect(page).to have_content("Zaakceptowany tytuł")
            expect(page).to have_content("treść rezenzji")
          end
        end

        context "recenzenci" do
          before do
            Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusa@gmail.com", sex:
                           "mężczyzna", roles: ['redaktor', 'recenzent'])
            article_file = Rails.root.join("spec/features/files/plik.pdf").open
            revision = ArticleRevision.create!(submission: Submission.first, pages: 1,
                                               pictures: 1, version: 1, received: "18-01-2016",
                                               article: article_file)
            Review.create!(article_revision: revision, deadline: '28/01/2016', person: Person.first,
                           status: "recenzja pozytywna", asked: '1/01/2016', content: "treść rezenzji")
          end

          scenario "link do listy recenzentów" do
            visit "/issues"

            click_link "3"
            expect(page).to have_link("Pokaż recenzentów")
          end

          scenario "wyświetlenie linku listy recenzentów" do
            visit "/issues"

            click_link "3"
            click_link "Pokaż recenzentów"
            expect(page).to have_content("Andrzej Kapusta")
          end
        end

        context "statystyki liczby opublikowanych artykułów" do
          before do
            Submission.create!(status:'przyjęty', language:"angielski", issue:
                               Issue.first, polish_title: "Statystyki artykułów",
                               english_title: "Article's statistics", english_abstract:
                               "statistics", english_keywords: "statistics, articles", received: "2015-02-17")
          end

          scenario "dostępność przeglądu statystyk" do
            visit "/issues"
            click_link "3"
            expect(page).to have_link("Statystyki")
          end

          scenario "wyświetlenie poszczególnych kategorii" do
            visit "/issues"
            click_link "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Statystyki"
            expect(page).to have_content("Liczba artykułów w j. angielskim")
            expect(page).to have_content("Liczba artykułów w j. polskim")
            expect(page).to have_content("Udział procentowy %")
          end

          scenario "prawidłowe wykonanie obliczeń" do
            visit "/issues"
            click_link "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Statystyki"
            expect(page).to have_content("50")
          end
        end

        context "liczba i udział procentowy autorów zagranicznych" do
          before do
            Country.create!(name: 'Polska')
            Country.create!(name: 'USA')
            Institution.create!(name: "Uniwersytet Jagielloński", country: Country.first)
            Institution.create!(name: "MIT", country: Country.last)
            Department.create!(name: "WZiKS", institution: Institution.first)
            Department.create!(name: "Department of Psychology", institution: Institution.last)
            Person.create!(name: 'Piotr', surname: 'Nieudolny', email: 'nieudolny@k.com',
                                     sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
            person1 = Person.create!(name: 'Jacek', surname: 'Zdolny', email: 'zdolny@n.com',
                                     sex: 'mężczyzna', roles: ['recenzent'], discipline:['filozofia'])
            person2 = Person.create!(name: 'Jakub', surname: 'Nieznany', email: 'nieznany@nd.com',
                                     sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
            person3 = Person.create!(name: 'Tymoteusz', surname: 'Znany', email: 'znany@n.com',
                                     sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
            person4 = Person.create!(name: 'Florian', surname: 'Zaspany', email: 'zaspany@n.com',
                                     sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
            Affiliation.create!(person: person1, department: Department.first, year_from: '2000', year_to: '2015')
            Affiliation.create!(person: person2, department: Department.first, year_from: '2000', year_to: '2015')
            Affiliation.create!(person: person3, department: Department.first, year_from: '2000', year_to: '2015')
            Affiliation.create!(person: person4, department: Department.last, year_from: '2000', year_to: '2015')
            Issue.create!(volume: 70, year: 2071)
            Submission.create!(language: "polski", received: "03-03-2016", status: "przyjęty", person: Person.first,
                               polish_title: "Arystoteles.", english_title: "title2", english_abstract: "abstract2",
                               english_keywords: "tag1, tag2", issue: Issue.first)
            Authorship.create!(person: person1, submission: Submission.first, position: 1, corresponding: true)
            Authorship.create!(person: person2, submission: Submission.first, position: 2, corresponding: false)
            Authorship.create!(person: person3, submission: Submission.first, position: 3, corresponding: false)
            Authorship.create!(person: person4, submission: Submission.first, position: 4, corresponding: false)
          end

          scenario "wyświetlenie statystyk" do
            visit "/issues"
            click_link "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Statystyki"

            expect(page).to have_content("Liczba autorów z afiliacją zagraniczną")
            expect(page).to have_content("Liczba autorów")
            expect(page).to have_content("Udział procentowy %")
          end

          scenario "właściwe wyniki" do
            visit "/issues"
            click_on "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Statystyki"

            expect(page).to have_content("1")
            expect(page).to have_content("4")
            expect(page).to have_content("25")
          end

          scenario "Brak autorów" do
            visit '/issues'
            click_on('70')
            click_on('Statystyki')

            expect(page).to have_content("0")
          end
        end

        context "przygotowany do wydania" do
          before do
            Issue.first.update_attributes(prepared: true)
            Article.create!(issue: Issue.first, submission:Submission.first, status: 'po recenzji')
          end

          scenario "brak numeru na liście wydanych numerów" do
            visit "/submissions"
            expect(page).not_to have_css("li a",text: "3/2020")
          end

          scenario "-> Wydanie numeru" do
            visit "/issues"
            click_link "3"
            expect(page).to have_content("Wydaj numer")

            click_link "Wydaj numer"
            expect(page).to have_content("3/2020 [OPUBLIKOWANY]")
          end

          context "-> Wydany numer" do
            before do
              Issue.first.update_attributes(published: true)
            end

            scenario "Pojawienie się numeru na liście wydanych numerów" do
              visit "/public_issues"
              expect(page).to have_css("li a",text: "3/2020")
            end

            scenario "Wyświetl wydany numer jako niezalogowany użytkownik" do
              visit "/public_issues"
              click_link "Wyloguj"

              visit "/public_issues"
              click_link "3/2020"
              expect(page).to have_content(/\[autor nieznany\].*Zaakceptowany tytuł/)
            end
          end
        end
      end

      scenario "-> Sprawdzenie czy nie da sie utworzyć rocznika z roku mniejszego niż 2000" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 2
          fill_in "Rok", with: 1999
        end
        click_button 'Utwórz'

        expect(page).to have_css(".has-error")
        expect(page).to have_content("musi być większe od 2000")
      end

      scenario "-> Sprawdzenie, czy da sie utworzyc rocznik z nieunikalnym numerem" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 1
          fill_in "Rok", with: 2001
        end
        click_button "Utwórz"

        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 1
          fill_in "Rok", with: 2001
        end
        click_button "Utwórz"

        expect(page).to have_css(".has-error")
        expect(page).to have_content("zostało już zajęte")
      end

      scenario "-> Sprawdzenie czy da sie utworzyć rocznik z numeru mniejszego niż 1" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 0
          fill_in "Rok", with: 2016
        end
        click_button 'Utwórz'

        expect(page).to have_css(".has-error")
        expect(page).to have_content("musi być większe od 0")
      end

    end
  end
end
