require 'rails_helper'

feature "zarządzanie osobami" do
  scenario "zarządzanie osobami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Zaloguj się'
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
        check "filozofia"
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
      
      before do

      Person.create!(name: "Andrzej", surname: "Kapusta", email: "a.kapusta@gmail.com", discipline: "filozofia", sex:

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
                       discipline: ["filozofia"], competence: "Arystoteles", sex: "mężczyzna", roles: ["redaktor"])
        Person.create!(name: "Wanda", surname: "Kalafior", email: "w.kalafior@gmail.com",
                       discipline: ["psychologia"], competence: "percepcja dźwięki", sex: "kobieta", roles: ["autor"])
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
        person_1 = Person.create!(name: "Andrzej", surname: "Ziemniak", email: "a.ziemniak@gmail.com", discipline: "filozofia", competence: "percepcja wzrokowa", sex: "mężczyzna", roles: ["autor"])
        person_2 = Person.create!(name: "Andrzej", surname: "Marchew", email: "a.marchew@gmail.com", discipline: "filozofia", competence: "percepcja dźwięki", sex: "mężczyzna", roles: ["recenzent"])
        person_3 = Person.create!(name: "Agata", surname: "Kalarepa", email: "a.kalarepa@gmail.com", discipline: "filozofia", competence: "percepcja dźwięki", sex: "kobieta", roles: ["recenzent"])
        submission = Submission.create!(language: "polski", received: "18-01-2016", status: "nadesłany", person: person_1, polish_title: "Arystoteles.", english_title: "title2", english_abstract: "abstract2",english_keywords: "tag1, tag2")
        
        article_revision_1 = ArticleRevision.create!(version:"1.0", received:"18-01-2016", pages:"5", submission: submission)
        article_revision_2 = ArticleRevision.create!(version:"2.0", received:"19-01-2016", pages:"5", submission: submission)
        article_revision_3 = ArticleRevision.create!(version:"3.0", received:"20-01-2016", pages:"5", submission: submission)
        article_revision_4 = ArticleRevision.create!(version:"4.0", received:"21-01-2016", pages:"5", submission: submission)
        article_revision_5 = ArticleRevision.create!(version:"5.0", received:"22-01-2016", pages:"5", submission: submission)

        Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_2, article_revision: article_revision_2)
        Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_2, article_revision: article_revision_3)
        Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_2, article_revision: article_revision_4)
        Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_2, article_revision: article_revision_5)
         Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_2, article_revision: article_revision_2)
          Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_3, article_revision: article_revision_3)
           Review.create!(status: "recenzja pozytywna", content: " ", asked: "20-02-2016", deadline: "16-01-2017", person:
                       person_3, article_revision: article_revision_3)
        
        
          end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Marchew")
        expect(page).to have_content("Gratulujemy i bardzo dziękujemy!")
        expect(page).to have_content("5")
        end

      scenario "wyświetlenie szczegółów osoby" do
        visit "/people"
        click_link("Kalarepa")
        expect(page).not_to have_content("Gratulujemy i bardzo dziękujemy!")
        
        end

      end


end
