require 'rails_helper'


feature "Sprawdzanie opublikowanych numerów" do
   before do 
     editor = Person.create(name: 'Adam', surname: 'Kapusta', email: 'a.kapusta@gmail.com', sex: 'mężczyzna', roles: ['redaktor'])
     issue_1 = Issue.create(year: 2001, volume: 1, published: true)
     submission = Submission.create(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                        english_abstract: 'Tak po prostu', english_keywords: 'knowledge',
                                        person: editor, issue: issue_1, language: 'polski', received: '28-01-2016',
                                        status: 'przyjęty')
     submission2 = Submission.create(polish_title: 'Jerzozwież', english_title: 'Porcupine',
                                        english_abstract: 'O jerzozwieżach', english_keywords: 'zwierzęta',
                                        person: editor, issue: issue_1, language: 'polski', received: '28-01-2016',
                                        status: 'przyjęty')
     Article.create(submission: submission, issue: issue_1, status: 'po recenzji', DOI: 40000)
     Article.create(submission: submission2, issue: issue_1, status: 'opublikowany', DOI: 42000)    
   end

   scenario "Linki do numerów" do
     visit '/public_issues'
    
     click_on '1/2001'
     expect(current_path).to eq("/public_issues/1-2001")   
   end

   scenario "Linki do artykułów" do
     visit '/public_issues'

     click_on '1/2001'
     click_on 'Wiemy wszystko'
     
     submission_id = Submission.find_by_polish_title("Wiemy wszystko").id
     article_id = Article.find_by_submission_id(submission_id).id
     expect(current_path).to eq("/public_articles/#{article_id}-wiemy-wszystko")
   end
end
 
