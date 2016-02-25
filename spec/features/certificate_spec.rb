require 'rails_helper'

feature "generowanie zaświadczenia o wydaniu artykułu" do
  context "po zalogowaniu i opublikowaniu artykułu" do
    include_context "admin login"
    before do
      person1 = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a@k.com', sex: 'mężczyzna', roles: ['autor'],
                             discipline:['filozofia'])
      issue_1 = Issue.create!(year: 2001, volume: 1, published: true)
      submission1 = Submission.create!(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                     english_abstract: 'Tak po prostu', english_keywords: 'knowledge',
                                     issue: issue_1, person:person1, language: 'polski', received: '28-01-2016',
                                     status: 'przyjęty')
      Authorship.create!(person:person1, submission: submission1)
      Article.create!(submission: submission1, issue: issue_1, status: 'opublikowany', 
      DOI: 40000, external_link:'http://bulka', pages:'300')
    end
    scenario "Generowanie zaświadczenia" do  
      visit '/articles'
      click_on 'Wiemy wszystko'
      click_on 'Pobierz zaświadczenie o publikacji'
		
      expect(page.status_code).to be(200)
    end
  end  
end
