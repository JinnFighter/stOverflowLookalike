require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
In order to reduce reading time of answers to my questions
As an authenticated user
I want to be able to mark some answer as best answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question }
  given!(:other_question) { create :question }
  given!(:other_answer) { create :answer, question: question }

  scenario 'Unauthenticated user tries to mark answer as best' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'as author of question' do
      scenario 'marks answer as best', js: true do
        within "#answer_body_#{answer.id}" do
          click_on 'Mark as best'

          expect(page).to have_content 'Best Answer:'
        end
      end
    end

    context 'as not author of question' do
      before do
        visit question_path(other_question)
      end

      scenario 'tries to mark answer as best' do
        expect(page).to_not have_link 'Mark as best'
      end
    end
  end
end
