require 'rails_helper'


feature "Sprawdzanie opublikowanych numerów" do
<<<<<<< HEAD
   before do 
     person1 = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a@k.com', sex: 'mężczyzna', roles: ['autor'], discipline:['filozofia'])
     issue_1 = Issue.create!(year: 2001, volume: 1, published: true)
     submission1 = Submission.create!(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                        english_abstract: 'Tak po prostu', english_keywords: 'knowledge', 
                                        issue: issue_1, person:person1, language: 'polski', received: '28-01-2016',
                                        status: 'przyjęty')
     time1 = Time.now.to_i 
     Authorship.create!(person:person1, submission: submission1)
     Article.create!(submission: submission1, issue: issue_1, status: 'opublikowany', DOI: 40000,
                                        external_link:'http://bulka', pages:'300')
   end
=======
  before do
    editor = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a@k.com', sex: 'mężczyzna', roles: ['autor'],
                            discipline:['filozofia'])
    issue_1 = Issue.create!(year: 2001, volume: 1, published: true)
    submission = Submission.create!(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                    english_abstract: 'Tak po prostu', english_keywords: 'knowledge',
                                    person: editor, issue: issue_1, language: 'polski', received: '28-01-2016',
                                    status: 'przyjęty')
    submission2 = Submission.create!(polish_title: 'Jerzozwież', english_title: 'Porcupine',
                                     english_abstract: 'O jerzozwieżach', english_keywords: 'zwierzęta',
                                     person: editor, issue: issue_1, language: 'polski', received: '28-01-2016',
                                     status: 'przyjęty')
    Article.create!(submission: submission, issue: issue_1, status: 'po recenzji', DOI: 40000)
    Article.create!(submission: submission2, issue: issue_1, status: 'opublikowany', DOI: 42000)
  end
>>>>>>> 70b2669e465fefee495e87c7221ab9b0bcecd1b2

  scenario "Linki do numerów" do
    visit '/public_issues'

    click_on '1/2001'
    expect(page).to have_content("Wiemy wszystko")
  end

  scenario "Linki do artykułów" do
    visit '/public_issues'

    click_on '1/2001'
    click_on 'Wiemy wszystko'
    expect(page).to have_content("Tak po prostu")
  end
end

