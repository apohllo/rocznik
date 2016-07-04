require "rails_helper"
require "capybara/email/rspec"

feature "Komunikacja z recenzentem" do
  context "-> Po zalogowaniu" do
    include_context "admin login"
    let(:review)    { create(:review, status: 'proponowany recenzent') }
    let(:editor)    { review.submission.person }
    let(:reviewer)  { review.person }

    before do
      review
    end

    scenario "-> Podgląd zapytania o recenzję" do
      clear_emails
      visit '/submissions'
      click_link review.submission_title
      click_link 'Wyślij zapytanie o sporządzenie recenzji'
      expect(page).to have_content reviewer.surname
      expect(page).to have_content review.submission_title
      expect(page).to have_content review.abstract
    end


    context "-> Recenzja już została przyjęta" do
      let(:review)    { create(:review, status: 'recenzja przyjęta') }

      scenario "-> Brak linku do zapytania o recenzję" do
        visit '/submissions'
        click_link review.submission_title
        expect(page).not_to have_link('Wyślij zapytanie o sporządzenie recenzji')
      end
    end

    context "-> Po przejściu do podglądu" do
      before do
        clear_emails
        visit '/submissions'
        click_link review.submission_title
        click_link 'Wyślij zapytanie o sporządzenie recenzji'
      end

      scenario "-> Wysłanie zapytanie o sporządzenie recenzji" do
        click_link 'Wyślij'
        open_email(reviewer.email)
        expect(current_email).to have_content reviewer.surname
        expect(current_email).to have_content review.submission_title
        expect(current_email).to have_content review.abstract
        expect(page).not_to have_link('Wyślij zapytanie o sporządzenie recenzji')
      end

      context "-> Po wysłaniu recenzji" do
        before do
          click_on 'Wyślij'
        end

        scenario "-> Można edytować recenzję" do
          click_link 'Edytuj recenzję'
          expect(page).to have_content(review.title)
        end

        scenario "-> Recenzja posiada date wysłania zapytania" do
          expect(page).to have_content(Time.now.strftime("%d-%m-%Y"))
        end

        scenario "-> Akceptacja recenzji" do
          open_email(reviewer.email)
          expect(current_email).to have_link 'Akceptuję recenzję'
          current_email.click_on 'Akceptuję recenzję'
          expect(page).to have_content 'recenzja przyjęta'
        end

        scenario "-> Odrzucenie recenzji" do
          open_email(reviewer.email)
          expect(current_email).to have_link 'Nie akceptuję recenzji'
          current_email.click_on 'Nie akceptuję recenzji'
          expect(page).to have_content 'recenzja odrzucona'
        end

        scenario "-> Sprawdzenie wysłania mejla do redaktora po zmianie statusu recenzji" do
          open_email(reviewer.email)
          current_email.click_on 'Akceptuję recenzję'
          open_email(editor.email)
          expect(current_email).to have_content 'recenzja przyjęta'
        end
      end
    end
  end
end
