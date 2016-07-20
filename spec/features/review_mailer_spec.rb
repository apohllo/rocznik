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
      expect(page).to have_content 'Szanowna Pani Profesor,'
      expect(page).to have_content review.submission_title
      expect(page).to have_content review.abstract
      expect(page).to have_content 'tekst jest w języku polskim'
      expect(page).to have_content '2 miesiące'
      expect(page).to have_content 'Pani'
    end

    context "-> Tekst w języku angielski" do
      before do
        review.submission.language = 'angielski'
        review.submission.save!
      end

      scenario "->  Podgląd zapytania o recenzję" do
        visit '/submissions'
        click_link review.submission_title
        click_link 'Wyślij zapytanie o sporządzenie recenzji'
        expect(page).to have_content 'tekst jest w języku angielskim'
      end
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

      scenario "-> Bez wysłania zapytania" do
        click_link 'Akceptuję recenzję'
        expect(page).to have_content 'W celu potwierdzenia decyzji o przyjęciu'
      end

      scenario "-> Wysłanie zapytanie o sporządzenie recenzji" do
        click_link 'Wyślij'
        open_email(reviewer.email)
        expect(current_email).to have_content 'Szanowna Pani Profesor,'
        expect(current_email).to have_content review.submission_title
        expect(current_email).to have_content review.abstract
        expect(current_email).to have_content 'tekst jest w języku polskim'
        expect(current_email).to have_content '2 miesiące'
        expect(current_email).to have_content 'Pani'
        expect(current_email.header('From')).to eq editor.email
        expect(page).not_to have_link('Wyślij zapytanie o sporządzenie recenzji')
      end

      context "-> Tekst w języku angielski" do
        before do
          review.submission.language = 'angielski'
          review.submission.save!
        end

        scenario "-> Wysłanie zapytanie o sporządzenie recenzji" do
          click_link 'Wyślij'
          open_email(reviewer.email)
          expect(current_email).to have_content 'tekst jest w języku angielskim'
        end
      end

      context "-> Po wysłaniu recenzji" do
        before do
          click_on 'Wyślij'
        end

        scenario "-> Można edytować recenzję" do
          click_link 'Edytuj recenzję'
          expect(page).to have_content(review.title)
        end

        scenario "-> Recenzja posiada datę wysłania zapytania" do
          expect(page).to have_content(Time.now.strftime("%d-%m-%Y"))
        end

        scenario "-> Akceptacja recenzji" do
          click_on 'Akceptacja recenzji'
          expect(page).to have_content 'recenzja przyjęta'
          expect(page).not_to have_link 'Akceptacja recenzji'
        end


        scenario "-> Odrzucenie recenzji" do
          click_on 'Odrzucenie recenzji'
          expect(page).to have_content 'recenzja odrzucona'
          expect(page).not_to have_link 'Odrzucenie recenzji'
        end

        context '-> Recenzent' do
          before do
            click_link 'Wyloguj'
          end

          scenario "-> Akceptacja recenzji" do
            open_email(reviewer.email)
            expect(current_email).to have_link 'Akceptuję recenzję'
            current_email.click_on 'Akceptuję recenzję'
            expect(page).to have_content 'W celu potwierdzenia decyzji o przyjęciu'
            fill_in "Adres e-mail", with: reviewer.email
            click_on 'Potwierdź'
            expect(page).to have_content 'Niebawem'
          end

          scenario "-> Odrzucenie recenzji" do
            open_email(reviewer.email)
            expect(current_email).to have_link 'Nie akceptuję recenzji'
            current_email.click_on 'Nie akceptuję recenzji'
            expect(page).to have_content 'W celu potwierdzenia decyzji o odrzuceniu'
            fill_in "Adres e-mail", with: reviewer.email
            click_on 'Potwierdź'
            expect(page).to have_content 'Szanujemy'
          end

          context "-> Po potwierdzeniu recenzji" do
            before do
              open_email(reviewer.email)
              current_email.click_on 'Akceptuję recenzję'
              fill_in "Adres e-mail", with: reviewer.email
              click_on 'Potwierdź'
            end

            scenario "-> Sprawdzenie wysłania mejla do redaktora po zmianie statusu recenzji" do
              open_email(editor.email)
              expect(current_email).to have_content 'recenzja przyjęta'
            end

            scenario "-> Ponowne potwierdzenie recenzji" do
              open_email(reviewer.email)
              current_email.click_on 'Akceptuję recenzję'
              expect(page).to have_content 'Decyzja o akceptacji recenzji została już podjęta'
            end
          end
        end
      end
    end
  end
end
