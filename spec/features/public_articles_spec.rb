require 'rails_helper'


feature "Sprawdzanie opublikowanych artykulów" do
   include_context "admin login"
   before do 
     
     person1 = Person.create(name: 'Adam', surname: 'Kapusta', email: 'a@k.com', sex: 'mężczyzna', roles: ['autor'])
     person_id = Person.find_by_name("Adam")
     issue_1 = Issue.create(year: 2001, volume: 1, published: true)
     submission = Submission.create(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                        english_abstract: 'Tak po prostu', english_keywords: 'knowledge', person_id:person_id, 
                                        issue: issue_1, language: 'polski', received: '28-01-2016',
                                        status: 'przyjęty')
     Article.create(submission: submission, issue: issue_1, status: 'opublikowany', DOI: 40000,
                                        external_link:'http://bulka', pages:'300')
     visit '/public_issues'
     click_on '1/2001'
     click_on 'Wiemy wszystko'

   end

   scenario "Tytul strony" do
     expect(page).to have_content("Wiemy wszystko") 
   end

   scenario "Autor" do
     expect(page).to have_content("Adam Kapusta")  
   end

   scenario "Streszczenie" do
     expect(page).to have_content("Tak po prostu")  
   end

   scenario "Slowa kluczowe" do
     expect(page).to have_content("knowledge")  
   end

   scenario "Link do ściągnięcia" do
     expect(page).to have_content("http://bulka")  
   end

   scenario "Strony" do
     expect(page).to have_content("300")  
   end

   scenario "Numer" do
     expect(page).to have_content("1/2001")  
   end

end
 
