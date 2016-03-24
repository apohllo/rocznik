require 'rails_helper'

feature "Publiczne dodawanie zgłoszenia" do
  let(:submission)    { build(:submission) }
  let(:revision)      { build(:article_revision, submission: Submission.first) }
  let(:author)        { build(:author) }
  let(:editor)        { build(:editor) }

  before do
    submission
    revision
    author
    editor
  end

  scenario "-> Użycie linku w menu bocznym" do
    visit '/public_issues'
    click_on('Zgłoś artykuł')

    expect(page).to have_text("Nowe zgłoszenie")
    expect(page).to have_button("Dalej")
  end

  scenario "-> Dodanie tytułu i innych danych zgłoszenia" do
    visit '/public_submissions/new/'

    within("#new_submission") do
       fill_in "Tytuł polski", with: submission.title
       fill_in "Tytuł angielski", with: submission.english_title
       fill_in "Streszczenie", with: submission.abstract
       fill_in "Słowa kluczowe", with: submission.keywords
       select submission.language, from: "Język"
       fill_in "Finansowanie", with: submission.funding
       fill_in "Liczba stron", with: revision.pages
       fill_in "Liczba ilustracji", with: revision.pictures
       attach_file("Artykuł", revision.article.path)
     end

    click_button("Dalej")
    expect(page).not_to have_css(".has-error")
  end

  context "-> Po wypełnieniu podstawowych danych" do
    before do
      visit '/public_submissions/new/'
      within("#new_submission") do
         fill_in "Tytuł polski", with: submission.title
         fill_in "Tytuł angielski", with: submission.english_title
         fill_in "Streszczenie", with: submission.abstract
         fill_in "Słowa kluczowe", with: submission.keywords
         select submission.language, from: "Język"
         fill_in "Finansowanie", with: submission.funding
         fill_in "Liczba stron", with: revision.pages
         fill_in "Liczba ilustracji", with: revision.pictures
         attach_file("Artykuł", revision.article.path)
       end

      click_button("Dalej")
    end

    scenario "-> Uzupełnienie danych autora" do
      expect(page).to have_content("Dodaj autora")

      within("#new_authorship") do
        fill_in "Imię", with: author.name
        fill_in "Nazwisko", with: author.surname
        fill_in "E-mail", with: author.email
        select author.sex, from: "Płeć"
      end

      click_button("Dodaj autora")
      expect(page).not_to have_css(".has-error")
      expect(page).to have_content(author.name)
      expect(page).to have_content(author.surname)
    end

    context "-> Po uzupełnieniu danych pierwszego autora" do
      before do
        within("#new_authorship") do
          fill_in "Imię", with: author.name
          fill_in "Nazwisko", with: author.surname
          fill_in "E-mail", with: author.email
          select author.sex, from: "Płeć"
        end

        click_button("Dodaj autora")
      end

      scenario "-> Finalizacja zgłoszenia" do
        click_button("Zakończ")
        expect(page).to have_content("Twoje zgłoszenie zostało wysłane")
        expect(Submission.count).to eq(1)

        expect(page).to have_content(submission.title)
        expect(page).to have_content(submission.abstract)
        expect(page).to have_content(submission.keywords)
        expect(page).to have_content(submission.language)
      end

      scenario "-> Anulowanie zgłoszenia" do
        expect(Submission.count).to eq(1)
        click_button("Rezygnuj")

        expect(page).to have_content("Twoje zgłoszenie zostało usunięte")
        expect(Submission.count).to eq(0)
      end

      scenario "-> Powiadomienie redaktorów" do
        clear_emails
        click_button("Zakończ")
        open_email(editor.email)
        expect(current_email).to have_content 'Zgłoszono nowy artykuł'
        expect(current_email).to have_content(submission.title)
        expect(current_email).to have_content(submission.abstract)
        expect(current_email).to have_content(submission.keywords)
        expect(current_email).to have_content(submission.language)
        expect(current_email.attachments.first.filename).to match(/\.pdf$/)
      end

      scenario "-> Powiadomienie autora korespondującego" do
        clear_emails
        click_button("Zakończ")
        open_email(author.email)
        expect(current_email).to have_content(submission.title)
        expect(current_email).to have_content 'zostało przyjęte do systemu'
      end
    end
  end
end
