require 'rails_helper'

feature "Artykuły" do

  context "Po zalogowaniu" do
    include_context "admin login"

    scenario "Sprawdzenie czy w menu jest odnośnik prowadzacy do artykułów" do
      visit '/issues/'

      expect(page).to have_link('Publikowane artykuły')
    end

    context "Z artykułem" do
      before do
        editor = Person.create!(name: 'Adam', surname: 'Kapusta', email: 'a.kapusta@gmail.com', sex: 'mężczyzna',
                                discipline: ['filozofia'], roles: ['redaktor'])
        issue_1 = Issue.create!(year: 2001, volume: 1)
        Issue.create!(year: 2002, volume: 2)
        submission = Submission.create!(polish_title: 'Wiemy wszystko', english_title: 'We know everything',
                                        english_abstract: 'Tak po prostu', english_keywords: 'knowledge',
                                        person: editor, issue: issue_1, language: 'polski', received: '28-01-2016',
                                        status: 'przyjęty')
        Article.create!(submission: submission, issue: issue_1)
      end

      scenario "Wyświetlanie artykułu" do
        visit '/articles'
        click_on 'Wiemy wszystko'

        expect(page).to have_content("1/2001")
      end

      scenario "Edycja artykułu" do
        visit '/articles'
        click_on 'Wiemy wszystko'
        click_on 'Edytuj'
        select "2/2002", from: "Numer"

        expect(page).not_to have_css('.has-error')
        expect(page).to have_content("2/2002")
      end
    end
  end
end
