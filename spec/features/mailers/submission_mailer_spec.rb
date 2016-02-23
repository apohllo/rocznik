require "rails_helper"
require "capybara/email/rspec"

feature "Wysłanie maila informującego o zmianie recenzji" do

  context "po zalogowaniu" do
    include_context "admin login"

    background do
      Person.create!(name: "Anna", surname: "Kowalska", email: "kowal76767@gmail.com",
                     sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
      Issue.create!(volume: 333, year: 2333)
      Submission.create!(status: "przyjęty", language: "polski", issue: Issue.first,
                         person: Person.first, received: "19-02-2015",
                         polish_title: "Polski tytuł",
                         english_title: "English title",
                         english_abstract: "Abstract", english_keywords: "title")
      article_file = Rails.root.join("spec/features/files/plik.pdf").open
    end

    scenario "sprawdzenie wysłania statusu odrzuconego w treści maila" do
      clear_emails
      visit '/submissions'
      click_link 'Polski tytuł'
      click_link 'Edytuj'
      select "odrzucony", from: "Status"
      click_on 'Zapisz'
      open_email('kowal76767@gmail.com')
      expect(current_email).to have_content 'odrzucony'
    end
  end
end
