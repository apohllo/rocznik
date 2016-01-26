require 'rails_helper'

feature "zarządzanie osobami" do
  scenario "zarządzanie osobami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "link do nowej osoby" do
      visit '/people'
      click_link 'Nowa osoba'

      expect(page).to have_css("#new_person input[value='Utwórz']")
    end

    scenario "tworzenie nowej osoby" do
      visit '/people/new'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
        fill_in "Nazwisko", with: "Kapusta"
        fill_in "E-mail", with: "a.kapusta@gmail.com"
        fill_in "Dyscyplina", with: "filozofia"
        fill_in "Kompetencje", with: "Arystoteles"
        select "mężczyzna", from: "Płeć", visible: false
        check "recenzent"
      end
      click_button 'Utwórz'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Andrzej")
      expect(page).to have_content("Kapusta")
      expect(page).to have_content("a.kapusta@gmail.com")
      expect(page).to have_content("Arystoteles")
      expect(page).to have_css("img[src*='person']")
    end


    scenario "tworzenie nowej osoby z brakującymi elementami" do
      visit '/people/new'

      within("#new_person") do
        fill_in "Imię", with: "Andrzej"
      end
      click_button 'Utwórz'

      expect(page).to have_css(".has-error")
    end
  end
    context "z jedną osobą w bazie danych" do
     
      include_context "admin login"
      #####################
      before do

        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia")      

        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia", sex: "mężczyzna")

      end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kapusta")
        expect(page).to have_css("h3", text: "Andrzej Kapusta")

    end

   # context "z dwoma osobami, które napisały recenzje w bazie danych" do
     # before do
    	#person1 =   Person.create!(name: "Izabella", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia", sex:"K", role_inclusion: "R")
      #  person2=Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia", sex: "M", role_inclusion: "R" ) 
  	#	Review.create!(status: :asked, person_id: person1.person_id, asked: Time.now )
  

      #end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kapusta")

        expect(page).to have_css("h3", text: "Andrzej Kapusta")

        expect(page).to have_css("dd", text: "mężczyzna")
      end

      scenario "dodanie zdjęcia" do
        visit '/people'
        click_on 'Kapusta'
        click_on 'Edytuj'

        attach_file("Zdjęcie", 'spec/features/files/man.png')
        click_button 'Zapisz'

        expect(page).to have_css("img[src*='man.png']")

      end
    end

    context "z dwoma osobami w bazie danych" do
      before do
        Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com",
                       discipline: "filozofia", competence: "Arystoteles", sex: "mężczyzna", roles: ["redaktor"])
        Person.create!(name: "Wanda", surname: "Kalafior", email: "w.kalafior@gmail.com",
                       discipline: "psychologia", competence: "percepcja dźwięki", sex: "kobieta", roles: ["autor"])
      end
    

      scenario "wyszukanie osoby" do
        visit "/people"
        fill_in "Nazwisko", with: "Kalafior"
        click_on("Filtruj")

        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrzej")
      end


      scenario "filtrowanie osob po roli" do
        visit "/people"
        select "autor", from: "Rola"
        click_on("Filtruj")

        expect(page).to have_content("Wanda")
        expect(page).not_to have_content("Andrze")
      end

    end

    context "Z uzytkownikiem, ktory ma pięć recenzji" do
      include_context "admin login"
      before do 
        person1 = Person.create!(name: "Andrzej", surname: "Ziemniak", email: "a.ziemniak@gmail.com", discipline: "filozofia", roles: 'A')
        person2 = Person.create!(name: "Andrzej", surname: "Marchew", email: "a.marchew@gmail.com", discipline: "filozofia", roles: 'R')
        person3 = Person.create!(name: "Agata", surname: "Kalarepa", email: "a.kalarepa@gmail.com", discipline: "filozofia", roles: 'R')
        submission = Submission.create(person_id: person1)
        
        revision1 = ArticleRevision.create!(submission: submission, pages: '100')
        revision2 = ArticleRevision.create!(submission: submission, pages: '100')
        revision3 = ArticleRevision.create!(submission: submission, pages: '100')
        revision4 = ArticleRevision.create!(submission: submission, pages: '100')
        revision5 = ArticleRevision.create!(submission: submission, pages: '100')
        revision6 = ArticleRevision.create!(submission: submission, pages: '100')
        revision7 = ArticleRevision.create!(submission: submission, pages: '100')
        revision8 = ArticleRevision.create!(submission: submission, pages: '100')
        
        
        Review.create!(status: :accepted, person_id: person2, asked: Time.now, article_revision_id: revision1.article_revision_id )
        Review.create!(status: :accepted, person_id: person2, asked: Time.now, article_revision_id: revision2.article_revision_id )
        Review.create!(status: :accepted, person_id: person2.person_id, asked: Time.now, article_revision_id: revision3.article_revision_id)
        Review.create!(status: :accepted, person_id: person2.person_id, asked: Time.now, article_revision_id: revision4.article_revision_id)
        Review.create!(status: :accepted, person_id: person2.person_id, asked: Time.now, article_revision_id: revision5.article_revision_id )
        Review.create!(status: :accepted, person_id: person3.person_id, asked: Time.now, article_revision_id: revision5.article_revision_id )
        Review.create!(status: :accepted, person_id: person3.person_id, asked: Time.now, article_revision_id: revision5.article_revision_id )
          end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Marchew")
        expect(page).to have_content("Gratulujemy i bardzo dziekujemy.")
        expect(page).to have_content("p", text: "5")
        end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kalarepa")
        expect(page).not_to have_content("Gratulujemy i bardzo dziekujemy.")
        
        end

      end


end
