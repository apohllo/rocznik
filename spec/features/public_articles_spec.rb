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
    Authorship.create!(person:person1, submission: submission1)
    Article.create!(submission: submission1, issue: issue_1, status: 'opublikowany', DOI: 40000,
                    external_link:'http://bulka', pages:'300')
  end

  before do
    visit '/public_issues'
    click_on '1/2001'
    click_on 'Wiemy wszystko'
  end

  scenario "-> Tytuł artykułu" do
    expect(page).to have_content("Wiemy wszystko")
  end

  scenario "-> Autor" do
    expect(page).to have_content("A. Kapusta")
  end

  scenario "-> E-mail autora korespondującego" do
    expect(page).to have_content("a@k.com")
  end

  scenario "-> Streszczenie" do
    expect(page).to have_content("Tak po prostu")
  end


  scenario "-> Słowa kluczowe" do
    expect(page).to have_content("knowledge")
  end

  xscenario "-> Link do pobrania" do
    expect(page).to have_content("http://bulka")
  end

  scenario "-> Strony" do
    expect(page).to have_content("300")
  end

  scenario "-> DOI" do
    expect(page).to have_content("40000")
  end

  scenario "-> Numer rocznika" do
    expect(page).to have_content("1/2001")
  end
end
