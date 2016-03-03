require "rails_helper"
require "capybara/email/rspec"

feature "Powiadamianie o nowym zgłoszeniu artykułu" do
  let(:email1) { 'em1@test.pl' }
  let(:email2) { 'em2@test.pl' }
  let(:submission_data) do
    {
      title: "Testowy tytuł zgłoszenia",
      english_title: "English title",
      abstract:  "absbabsba",
      keywords:  "englsh key words",
      language:  "Język",
      funding:  "UE",
      pages:  "11",
      pictures:  "5",
      file:  Rails.root + "spec/features/files/plik.pdf"
    }
  end

  background do
    Person.create!(name: "Joanna", surname: "Gąska", email: email1,
                   sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
    Person.create!(name: "Joanna", surname: "Gąska", email: email2,
                   sex: "kobieta", roles: ['redaktor','recenzent'], discipline: ["psychologia"])
  end

  scenario "zapytanie o sporządzenie recenzji" do
    clear_emails

    visit '/public_submissions/new/'

    within("#new_submission") do
       fill_in "Tytuł", with: submission_data[:title]
       fill_in "Title", with: submission_data[:english_title]
       fill_in "Abstract", with: submission_data[:abstract]
       fill_in "Key words", with: submission_data[:keywords]
       select "polski", from: submission_data[:language]
       fill_in "Finansowanie", with: submission_data[:funding]
       fill_in "Liczba stron", with: submission_data[:pages]
       fill_in "Liczba ilustracji", with: submission_data[:pictures]
       attach_file("Artykuł", submission_data[:file])
     end

    click_button("Dalej")

    within("#new_authorship") do
      fill_in "Imię", with: "Cokolwiek"
      fill_in "Nazwisko", with: "Brzdęk"
      fill_in "E-mail", with: "a@aa.com"
      select "mężczyzna", from: "Płeć"
      fill_in "Dyscyplina", with: "nauka"
    end

    click_button("Zapisz")

    open_email(email1)
    expect(current_email).to have_content 'Dodano nowe zgłoszenie'

    open_email(email2)
    expect(current_email).to have_content 'Dodano nowe zgłoszenie'
  end
end
