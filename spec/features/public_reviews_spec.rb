require "rails_helper"
require "capybara/email/rspec"

feature "Przygotowywanie recenzji przez recenzenta" do
  let(:review)    { create(:review, status: 'recenzja przyjęta') }
  let(:editor)    { review.submission.person }
  let(:reviewer)  { review.person }

  before do
    review
  end

  context "-> Po zalogowaniu jako administrator" do
    include_context "admin login"

    scenario "-> Podgląd listu dot. formularza recenzyjnego" do
      visit '/submissions'
      click_on review.submission_title
      click_on 'Wyślij formularz recenzyjny'
      expect(page).to have_content 'Szanowna Pani Profesor,'
      expect(page).to have_content review.submission_title
      expect(page).to have_content editor.full_name
      expect(page).to have_link 'formularza recenzyjnego'
    end

    context '-> Po przejściu do podlądu' do
      before do
        clear_emails
        visit '/submissions'
        click_on review.submission_title
        click_on 'Wyślij formularz recenzyjny'
      end

      scenario "-> Wysłanie formularza recenzyjnego" do
        click_on 'Wyślij'
        open_email(reviewer.email)
        expect(current_email).to have_content 'Szanowna Pani Profesor,'
        expect(current_email).to have_content review.submission_title
        expect(current_email).to have_content editor.full_name
        expect(current_email).to have_link 'formularza recenzyjnego'
        expect(current_email.header('From')).to eq editor.email
      end

      context '-> Formularz recenzyjny' do
        let(:decision)      { 'recenzja pozytywna' }
        let(:justification) { 'Tekst jest po prostu dobry' }
        let(:remarks)       { 'Brak uwag' }

        before do
          click_on 'Wyślij'
          click_link 'Wyloguj'
          open_email(reviewer.email)
          current_email.click_on 'formularza recenzyjnego'
        end

        scenario '-> Poprawna recenzja' do
          fill_in 'Adres e-mail', with: reviewer.email
          select decision, from: 'Decyzja'
          fill_in 'Uzasadnienie', with: justification
          fill_in 'Uwagi', with: remarks
          click_on 'Wyślij'
          expect(page).to have_content 'Dziękujemy'
          expect(page).to have_css 'img[src*="woman"]'
        end

        scenario '-> Niepoprawny e-mail' do
          fill_in 'Adres e-mail', with: "invalid@email.com"
          select decision, from: 'Decyzja'
          fill_in 'Uzasadnienie', with: justification
          click_on 'Wyślij'
          expect(page).to have_css '.has-error'
          expect(page).to have_content 'Adres e-mail jest niepoprawny'
        end

        scenario '-> Niepoprawna decyzja' do
          fill_in 'Adres e-mail', with: reviewer.email
          select '', from: 'Decyzja'
          fill_in 'Uzasadnienie', with: justification
          click_on 'Wyślij'
          expect(page).to have_css '.has-error'
          expect(page).to have_content 'nie znajduje się na liście'
        end

        context '-> Po wprowadzeniu recenzji' do
          before do
            fill_in 'Adres e-mail', with: reviewer.email
            select decision, from: 'Decyzja'
            fill_in 'Uzasadnienie', with: justification
            fill_in 'Uwagi', with: remarks
            click_on 'Wyślij'
          end

          scenario '-> Powiadomienie redaktora' do
            open_email(editor.email)
            expect(current_email).to have_content review.submission_title
            expect(current_email).to have_content decision
          end

          scenario '-> Smiana statusu recenzji' do
            review.reload
            expect(review.status).to eq decision
            expect(review.content).to eq justification
            expect(review.remarks).to eq remarks
          end
        end
      end
    end
  end
end
