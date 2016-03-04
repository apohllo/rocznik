require 'rails_helper'

feature "zarządzanie numerami" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/issues'

    expect(page).to have_content 'Zaloguj się'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "dostępność numerów w menu" do
      visit '/people'

      expect(page).to have_link("Numery rocznika")
    end

    scenario "wyświetlanie pustej listy numerów" do
      visit '/issues'

      expect(page).to have_css("h3", text: "Numery rocznika")
    end

    scenario "link do nowego numeru" do
      visit '/issues'
      click_link 'Nowy numer'

      expect(page).to have_css("#new_issue input[value='Utwórz']")
    end

    scenario "tworzenie nowego numeru" do
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

    context "liczba i udział procentowy recenzentów z uczelni" do
      before do
        Country.create!(name: 'Polska')
        Country.create!(name: 'USA')
        Institution.create!(name: "Uniwersytet Jagielloński", country: Country.first)
        Institution.create!(name: "MIT", country: Country.last)
        Department.create!(name: "WZiKS", institution: Institution.first)
        Department.create!(name: "Department of Psychology", institution: Institution.last)
        person0 = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a@k.com',
                        sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
        person1 = Person.create!(name: 'Andrzej', surname: 'Nowak', email: 'as@n.com',
                        sex: 'mężczyzna', roles: ['recenzent'], discipline:['filozofia'])
        person2 = Person.create!(name: 'Adam', surname: 'Kowalski', email: 'a@nd.com',
                        sex: 'mężczyzna', roles: ['recenzent'], discipline:['filozofia'])
        person3 = Person.create!(name: 'Andrzej', surname: 'Wójcik', email: 'adf@n.com',
                        sex: 'mężczyzna', roles: ['recenzent'], discipline:['filozofia'])
        person4 = Person.create!(name: 'Andrzej', surname: 'Kiepski', email: 'aasd@n.com',
                        sex: 'mężczyzna', roles: ['recenzent'], discipline:['filozofia'])
        Affiliation.create!(person: person1, department: Department.first, year_from: '2000', year_to: '2015')
        Affiliation.create!(person: person2, department: Department.first, year_from: '2000', year_to: '2015')
        Affiliation.create!(person: person3, department: Department.first, year_from: '2000', year_to: '2015')
        Affiliation.create!(person: person4, department: Department.last, year_from: '2000', year_to: '2015')
        Issue.create!(volume: 69, year: 2070)
        Issue.create!(volume: 70, year: 2071)
        Submission.create!(language: "polski", received: "03-03-2016", status: "przyjęty", person: Person.first,
                               polish_title: "Arystoteles.", english_title: "title2", english_abstract: "abstract2",
                               english_keywords: "tag1, tag2", issue: Issue.first)
        article_file = Rails.root.join("spec/features/files/plik.pdf").open
        ArticleRevision.create!(version:"1.0", received:"03-03-2016", pages:"5", code: "tekst_",
                                article: article_file, submission: Submission.first)
        Review.create!(article_revision: ArticleRevision.last, deadline: '29/03/2016', person: person1,
                        status: "recenzja pozytywna", asked: '03/03/2016', content: "treść rezenzji")
        Review.create!(article_revision: ArticleRevision.last, deadline: '30/03/2016', person: person2,
                        status: "recenzja pozytywna", asked: '03/03/2016', content: "treść rezenzji")
        Review.create!(article_revision: ArticleRevision.last, deadline: '31/03/2016', person: person3,
                        status: "recenzja pozytywna", asked: '03/03/2016', content: "treść rezenzji")
        Review.create!(article_revision: ArticleRevision.last, deadline: '01/04/2016', person: person4,
                        status: "recenzja pozytywna", asked: '03/03/2016', content: "treść rezenzji")
      end

      scenario "75% UJotu" do
        visit '/issues'
        click_on('69')
        click_on('Statystyki uczelni')

        expect(page).to have_content("Recenzenci z Uniwersytetu Jagiellońskiego: 3 (75%)")
        expect(page).to have_content("Recenzenci z innych uczelni: 1 (25%)")
      end

      scenario "Brak recenzentów" do
        visit '/issues'
        click_on('70')
        click_on('Statystyki uczelni')

        expect(page).to have_content("Recenzenci z Uniwersytetu Jagiellońskiego: 0 (0%)")
        expect(page).to have_content("Recenzenci z innych uczelni: 0 (0%)")
      end
    end

    context "proba test" do
      before do
        Issue.create!(volume: 98, year: 2098)
        Issue.create!(volume: 99, year: 2099)
        Submission.create!(status:'przyjęty', language:"polski", issue:
                           Issue.last, polish_title: "proba",
                           english_title: "test", english_abstract:
                           "english", english_keywords: "test,
                             exam", received: "2015-01-17")

      end

      scenario "sprawdzanie niedostepnosci linku" do
        visit '/issues/98-2098'

        expect(page).to have_css(".disabled")
      end

      scenario "sprawdzanie dostepnosci linku" do
        visit '/issues/99-2099'

        expect(page).not_to have_css(".disabled")
      end

      scenario "przygotowanie numeru do wydania" do
        visit '/issues/99-2099'
        click_link "Przygotuj do wydania"

        expect(page).to have_content("Przygotuj numer do wydania")
      end

      scenario "wyswietlenie publikowanych artykulow" do
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
            expect(page).to have_content("Liczba artykułów w j.ang.")
            expect(page).to have_content("Liczba artykułów")
            expect(page).to have_content("Udział procentowy %")
          end

          scenario "prawidłowe wykonanie obliczeń" do
            visit "/issues"
            click_link "3"
            click_link "Przygotuj do wydania"
            click_button "Przygotuj numer do wydania"
            click_link "Statystyki"
            expect(page).to have_content("50.0")
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
            person0 = Person.create!(name: 'Piotr', surname: 'Nieudolny', email: 'nieudolny@k.com',
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
            Issue.create!(volume: 69, year: 2070)
            Issue.create!(volume: 70, year: 2071)
            Submission.create!(language: "polski", received: "03-03-2016", status: "przyjęty", person: Person.first,
                               polish_title: "Arystoteles.", english_title: "title2", english_abstract: "abstract2",
                               english_keywords: "tag1, tag2", issue: Issue.first)
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
            visit '/issues'
            click_on('69')
            click_on('Statystyki')

            expect(page).to have_content("1")
            expect(page).to have_content("4")
            expect(page).to have_content("25.0")
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

          scenario "Wydanie numeru" do
            visit "/issues"
            click_link "3"
            expect(page).to have_content("Wydaj numer")

            click_link "Wydaj numer"
            expect(page).to have_content("3/2020 [OPUBLIKOWANY]")
          end
          context "wydany numer" do
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
              click_link "3/2020"
              expect(page).to have_content(/\[autor nieznany\].*Zaakceptowany tytuł/)
            end
          end
        end
      end

      scenario "Sprawdzenie czy nie da sie utworzyć rocznika z roku mniejszego niż 2000" do
        visit '/issues/new'

        within("#new_issue") do
          fill_in "Numer", with: 2
          fill_in "Rok", with: 1999
        end
        click_button 'Utwórz'

        expect(page).to have_css(".has-error")
        expect(page).to have_content("musi być większe od 2000")
      end

      scenario "Sprawdzenie, czy da sie utworzyc rocznik z nieunikalnym numerem" do
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

      scenario "Sprawdzenie czy da sie utworzyć rocznik z numeru mniejszego niż 1" do
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
