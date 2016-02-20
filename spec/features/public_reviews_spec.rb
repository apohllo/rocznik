require 'rails_helper'


feature "Formularz dodania proponowanych recenzentów" do
  before do
    person_1 = Person.create!(name:"Andrzej", surname:"Kapusta", sex: "mężczyzna",
 email:"a.kapusta@gmail.com", roles: ['redaktor'])
    submission_1 = Submission.create!(language: "polski", received: "18-01-2016",
 status: "nadesłany", person: person_1, polish_title: "Dlaczego solipsyzm?",
 english_title: "title1", english_abstract:"abstract1", english_keywords: "tag1, tag2")
    article_revision_1 = ArticleRevision.create!(version:"1.0", received:"18-01-2016",
 pages:"5", submission: submission_1)
  end
 
  scenario "Dodawanie proponowanego recenzenta" do
      visit '/public_reviews/new_reviewer'

      within("#new_person") do
        select "Dlaczego solipsyzm?", from: "article_revision"
        fill_in "Imię", with: "Anna"
        fill_in "Nazwisko", with: "Genialna"
        fill_in "E-mail", with: "a.genialna@gmail.com"
        select "kobieta", from: "Płeć", visible: false
      end
      click_button 'Dodaj propozycję'

      expect(page).not_to have_css(".has-error")
      expect(page).to have_content("Andrzej")
      expect(page).to have_content("Kapusta")

      click_button 'Zakończ dodawanie recenzentów'
      expect(page).to have_content("Dziękujemy za podanie propozycji recenzentów.")
    end

end
