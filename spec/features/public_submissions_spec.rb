require 'rails_helper'

feature "publiczne dodawanie zgloszenia" do
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

  scenario "użycie linku w menu bocznym" do
    visit '/'
    click_on('Zgłoś artykuł')

    expect(page).to have_text("Nowe zgłoszenie")
    expect(page).to have_button("Dalej")
  end

  scenario "tworzenie nowego zgloszenia" do
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

    expect(page).not_to have_css(".has-error")
    expect(page).to have_content("Dodaj autora")

    within("#new_authorship") do
      fill_in "Imię", with: "Cokolwiek"
      fill_in "Nazwisko", with: "Brzdęk"
      fill_in "E-mail", with: "a@aa.com"
      select "mężczyzna", from: "Płeć"
      fill_in "Dyscyplina", with: "nauka"
    end

    click_button("Zapisz")

    expect(page).not_to have_css(".has-error")
    expect(page).to have_content("Twoje zgłoszenie zostało zapisane")
    expect(Submission.count).to eq(1)

    expect(page).to have_content(submission_data[:title])
    expect(page).to have_content(submission_data[:abstract])
    expect(page).to have_content(submission_data[:keywords])
    expect(page).to have_content(submission_data[:language])
    expect(page).to have_content(submission_data[:funding])
    expect(page).to have_content(submission_data[:pages])
    expect(page).to have_content(submission_data[:pictures])
  end

  scenario "Anulowanie zgłoszenia" do
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

    expect(Submission.count).to eq(1)

    click_button("Anuluj")

    expect(page).to have_content("Twoje zgłoszenie zostało usunięte")
    expect(Submission.count).to eq(0)
  end
end
