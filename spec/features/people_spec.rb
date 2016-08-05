require 'rails_helper'

feature 'Zarządzanie osobami' do
  scenario '-> Zarządzanie osobami bez uprawnień' do
    visit '/people'

    expect(page).to have_content 'Zaloguj się'
  end

  context '-> Kobieta' do
    let(:person)    { create(:author, sex: Person::FEMALE, surname: "Kowalska") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowna Pani"
    end

    it "-> Tworzy właściwą formę płci" do
      expect(person.gender_name).to eq "Pani"
    end
  end

  context '-> Kobieta z dr' do
    let(:person)    { create(:author, sex: Person::FEMALE, surname: "Kowalska", degree: "dr") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowna Pani Doktor"
    end
  end

  context '-> Kobieta z dr hab.' do
    let(:person)    { create(:author, sex: Person::FEMALE, surname: "Kowalska", degree: "dr hab.") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowna Pani Profesor"
    end
  end

  context '-> Mężczyzna' do
    let(:person)    { create(:author, sex: Person::MALE, surname: "Kowalski") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowny Panie"
    end

    it "-> Tworzy właściwą formę płci" do
      expect(person.gender_name).to eq "Pan"
    end
  end

  context '-> Mężczyzna z dr' do
    let(:person)    { create(:author, sex: Person::MALE, surname: "Kowalski", degree: "dr") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowny Panie Doktorze"
    end
  end

  context '-> Mężczyzna z prof.' do
    let(:person)    { create(:author, sex: Person::MALE, surname: "Kowalski", degree: "prof. dr hab. inż") }

    it "-> Tworzy właściwe pozdrowienie" do
      expect(person.salutation).to eq "Szanowny Panie Profesorze"
    end
  end

  context '-> Po zalogowaniu' do
    include_context 'admin login'

    context "22 osoby" do
      before do
        22.times do |index|
          create(:author, email: "person#{index+1}@localhost.com")
        end
      end

      scenario "-> Na stronie wyświetlanych jest tylko 20 osób" do
        visit "/people"
        expect(page).to have_content("person1@localhost.com")
        expect(page).not_to have_content("person22@localhost.com")

        expect(page).to have_link('2')

        click_on "2"
        expect(page).to have_content("person22@localhost.com")
      end
    end

    scenario '-> Link do nowej osoby' do
      visit '/people'
      click_link 'Nowa osoba'

      expect(page).to have_css("#new_person input[value='Utwórz']")
    end

    scenario '-> Layout dla administratora' do
      visit '/people'
      expect(page).not_to have_css('#sidebar')

      visit '/public_issues'
      expect(page).to have_css('#sidebar')
    end

    scenario '-> Tworzenie nowej osoby' do
      visit '/people/new'
      author = build(:author)

      within('#new_person') do
        fill_in 'Imię', with: author.name
        fill_in 'Nazwisko', with: author.surname
        fill_in 'E-mail', with: author.email
        author.discipline.each do |discipline|
          check discipline
        end
        fill_in 'Kompetencje', with: author.competence
        select author.sex, from: 'Płeć'
        author.roles.each do |role|
          check role
        end
      end
      click_button 'Utwórz'

      expect(page).not_to have_css('.has-error')
      expect(page).to have_content(author.name)
      expect(page).to have_content(author.surname)
      expect(page).to have_content(author.email)
      expect(page).to have_content(author.competence)
      expect(page).to have_content(author.discipline.first)
      expect(page).to have_css("img[src*='person']")
    end

    scenario '-> Tworzenie osoby z podaniem niepoprawnego stopnia naukowego' do
      visit '/people/new'

      author = build(:author, degree: 'profesor')

      within('#new_person') do
        fill_in 'Stopień', with: author.degree
        fill_in 'Imię', with: author.name
        fill_in 'Nazwisko', with: author.surname
        fill_in 'E-mail', with: author.email
        check author.discipline.first
        fill_in 'Kompetencje', with: author.competence
        select author.sex, from: 'Płeć'
        check author.roles.first
      end
      click_button 'Utwórz'

      expect(page).to have_css('.has-error')
      expect(page).to have_content("dopuszczalne: lic., inż., mgr, dr, prof.")
    end

    scenario "-> Tworzenie nowej osoby z brakującymi elementami" do
      visit '/people/new'

      author = build(:author, degree: 'profesor')
      within("#new_person") do
        fill_in "Imię", with: author.name
      end
      click_button 'Utwórz'

      expect(page).to have_css(".has-error")
      expect(page).to have_content("nie może być puste")
    end

    context '-> Z autorem w bazie danych' do
      let(:author)  { create(:author) }
      let(:subject) { 'Pierwszy mejl' }
      let(:body)    { 'Treść mejla' }

      before do
        author
      end

      scenario '-> Wyświetlenie szczegółów osoby' do
        visit '/people'
        click_link(author.surname)
        expect(page).to have_css("h3", text: "#{author.name} #{author.surname}")
        expect(page).to have_content(author.sex)
      end

      scenario '-> Dodanie zdjęcia' do
        visit '/people'
        click_on author.surname
        click_on 'Edytuj'

        attach_file('Zdjęcie', 'spec/features/files/man.png')
        click_button 'Zapisz'

        expect(page).to have_css("img[src*='man.png']")
      end

      scenario '-> Wysłanie wiadomości do osoby' do
        visit '/people'
        click_on author.surname
        click_on 'Napisz wiadomość'
        expect(page).to have_css('h3', text: "Nowa wiadomość do #{author.email}")
        fill_in 'Tytuł', with: subject
        fill_in 'Treść', with: body
        click_on 'Wyślij'
        open_email(author.email)
        expect(current_email).to have_content(body)
      end

      context '-> Z recenzentem w bazie danych' do
        let(:reviewer)    { create(:reviewer) }
        before do
          reviewer
        end

        scenario "-> Wyszukanie osoby po nazwisku" do
          visit "/people"
          fill_in "Nazwisko", with: author.surname
          click_on("Filtruj")

          expect(page).to have_content(author.name)
          expect(page).not_to have_content(reviewer.name)
        end

        scenario "> Filtrowanie osób po roli" do
          visit "/people"
          select author.roles.first, from: "Rola"
          click_on("Filtruj")

          expect(page).to have_content(author.name)
          expect(page).not_to have_content(reviewer.name)
        end

        scenario "-> Filtrowanie osób po dyscyplinie" do
          visit "/people"
          select author.discipline.first, from: "Dyscypliny"
          click_on("Filtruj")

          expect(page).to have_content(author.name)
          expect(page).not_to have_content(reviewer.name)
        end

        scenario "-> Wyświetlenie statusu recenzenta" do
          visit "/people"
          click_on author.surname
          expect(page).not_to have_content("Status recenzenta")

          visit "/people"
          click_on reviewer.surname
          expect(page).to have_content("Status recenzenta")
        end

        scenario "-> Zmiana statusu recenzenta" do
          visit "/people"
          click_on reviewer.surname
          click_on 'Edytuj'
          select "Recenzuje po terminie", from: "Status recenzenta"
          click_on 'Zapisz'
          expect(page).to have_content("Recenzuje po terminie")
        end

        xscenario "-> Sprawdzanie przekierowania do wyszukiwarki Google", js: true do
          visit "/people"
          click_on reviewer.surname
          google_window = window_opened_by { click_link 'Google' }

          withine_window google_window do
            expect(page).to have_current_path('google.pl')
          end
        end

        xscenario "-> Reset filtrów i formularza", js: true do
          visit "/people"
          fill_in "Nazwisko", with: "Kalafior"
          expect(page).to have_xpath("//input[@value='Kalafior']")
          click_button 'x'
          find_field('Nazwisko').value.blank?
          select "autor", from: "Rola"
          click_button 'Filtruj'
          expect(page).to have_content("Wanda")
          expect(page).not_to have_content("Andrzej")
          click_button 'x'
          expect(page).to have_content("Wanda")
          expect(page).to have_content("Andrzej")
        end

        xscenario "-> Potwierdzenie przy usuwaniu zgłoszenia w widoku osoby" do
          visit "/people"
          click_on 'Kalafior'
          click_on 'Dodaj zgłoszenie'

          within("#new_submission") do
            fill_in "Tytuł", with: "Testowy tytuł zgłoszenia"
            fill_in "Title", with: "English title"
            fill_in "Abstract", with: "abc"
            fill_in "Key words", with: "def"
            fill_in "Otrzymano", with: "19/2/2016"
            select "Andrzej Kapusta", from: "Redaktor"
          end
          click_button("Utwórz")

          visit "/people"
          click_on 'Kalafior'
          page.find(".btn-danger").click
          expect(page).to have_content("Zapytanie")
        end

        xscenario "-> Potwierdzenie przy usuwaniu redagowanego artykulu" do
          visit "/people"
          click_on 'Kalafior'
          click_on 'Dodaj zgłoszenie'

          within("#new_submission") do
            fill_in "Tytuł", with: "Testowy tytuł zgłoszenia"
            fill_in "Title", with: "English title"
            fill_in "Abstract", with: "ah"
            fill_in "Key words", with: "def"
            fill_in "Otrzymano", with: "12/1/2016"
            select "Andrzej Kapusta", from: "Redaktor"
          end
          click_button("Utwórz")

          visit "/people"
          click_on 'Kalafior'
          page.find(".btn-danger").click
          expect(page).to have_content("Zapytanie")
        end

        scenario "-> Sprawdzenie unikalności adresu e-mail" do
          visit '/people/new'
          within("#new_person") do
            fill_in "Imię", with: "Anna"
            fill_in "Nazwisko", with: "Kowalska"
            fill_in "E-mail", with: author.email
            check "filozofia"
            fill_in "Kompetencje", with: "Foucault"
            select "kobieta", from: "Płeć"
            check "recenzent"
          end
          click_button 'Utwórz'
          expect(page).to have_css(".has-error")
          expect(page).to have_content("zajęte")
        end

        context "-> Z redaktorem i pięcioma recenzjami" do
          let(:editor)      { create(:editor) }
          let(:submission)  { create(:submission, person: editor) }

          before do
            5.times do
              revision = create(:article_revision,submission: submission)
              create(:review,article_revision: revision, person: reviewer)
            end
            create(:review, article_revision: ArticleRevision.first, person: editor)
          end

          scenario "wyświetlenie szczegółów osoby" do
            visit "/people"
            click_link reviewer.surname
            expect(page).to have_content("Gratulujemy i bardzo dziękujemy!")
            expect(page).to have_content("5")
          end

          scenario "wyświetlenie szczegółów osoby" do
            visit "/people"
            click_link editor.surname
            expect(page).not_to have_content("Gratulujemy i bardzo dziękujemy!")
          end
        end
      end
    end

    context "z dwoma osobami w bazie danych przy usunięciu recenzji (bez drugiego artykułu, konflikt)" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com",
                       competence: "Arystoteles", sex: "mężczyzna", roles: ["redaktor", "autor"],
                       discipline: ["filozofia"])
        Person.create!(name: "Krystyna", surname: "Pawłowicz", email: "w.kalafior@gmail.com",
                       competence: "percepcja dźwięki", sex: "kobieta",
                       roles: ["redaktor", "recenzent"], discipline: ["etyka"])
      end

      xscenario "potwierdzenie przy usuwaniu recenzji" do
        visit "/people"
        click_on 'Kapusta'
        click_on 'Dodaj zgłoszenie'

        within("#new_submission") do
          fill_in "Tytuł", with: "Głupi artykuł"
          fill_in "Title", with: "English title"
          fill_in "Abstract", with: "abc"
          fill_in "Key words", with: "def"
          fill_in "Otrzymano", with: "19/2/2016"
          select "Krystyna Pawłowicz", from: "Redaktor"
        end
        click_button "Utwórz"

        visit "/submissions/"
        click_on "Głupi artykuł"
        click_on 'Dodaj wersję'

        fill_in "Otrzymano", with: "19/02/2016"
        fill_in "Liczba stron", with: '2'
        fill_in "Liczba ilustracji", with: '1'
        attach_file("Artykuł", 'spec/features/files/plik.pdf')
        click_button 'Dodaj'

        within("#version") do
          expect(page).to have_content("plik.pdf")
          expect(page).to have_content("19-02-2016")
          expect(page).to have_css("a[title='Edytuj komentarz']")
        end

        visit "/people"
        click_on 'Pawłowicz'
        click_on 'Dodaj recenzję'

        within("#new_review") do
          select "Głupi artykuł, v. 1", from: "Artykuł (wersja)"
          select "Pawłowicz, Krystyna", from: "Recenzent"
          select "wysłane zapytanie", from: "Status"
          fill_in "Zapytanie wysłano", with: "20/02/2016"
          fill_in "Deadline", with: "05/03/2016"
          fill_in "Uwagi", with: "Naucz się pisać!"
        end
        click_button 'Dodaj'
        visit "/people"
        click_on 'Kapusta'
        page.find(".btn-danger").click
        expect(page).to have_content("Zapytanie")
      end
    end

  end
end
