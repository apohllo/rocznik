require 'rails_helper'


feature "Sprawdzanie opublikowanych artykulów" do
  before do
    person1 = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a@k.com', sex: 'mężczyzna', roles: ['autor'],
                             discipline:['filozofia'])
    issue_1 = Issue.create!(year: 2001, volume: 1, published: true)
    submission1 = Submission.create!(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                     english_abstract: 'Tak po prostu', english_keywords: 'knowledge',
                                     issue: issue_1, person:person1, language: 'polski', received: '28-01-2016',
                                     status: 'przyjęty')
    Authorship.create!(person:person1, submission: submission1, role: "autor")
    Article.create!(submission: submission1, issue: issue_1, status: 'opublikowany', DOI: 40000,
                    external_link:'http://bulka', pages:'300')
  end

  scenario "Tresc artykulu" do
    visit '/public_issues'
    click_on '1/2001'
    click_on 'Wiemy wszystko'

    expect(page).to have_content("Wiemy wszystko")
    expect(page).to have_content("A. Kapusta")
    expect(page).to have_content("a@k.com")
    expect(page).to have_content("Tak po prostu")
    expect(page).to have_content("knowledge")
    expect(page).to have_content("http://bulka")
    expect(page).to have_content("300")
    expect(page).to have_content("1/2001")
  end

end

