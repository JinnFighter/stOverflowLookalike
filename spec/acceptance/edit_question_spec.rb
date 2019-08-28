require_relative 'acceptance_helper'

feature 'Question editing', %q{
In order to be able to make questions more understandable
As an authenticated user
I want to be able to edit my questions
} do
  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given(:other_question) { create :question }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees edit link' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'tries to edit his question', js: true do
      click_link 'Edit question'
      wait_for_ajax

      within '#question_data' do
        fill_in 'edit_question_body', with: 'edited question'

        click_on 'Save'

        expect(page).to_not have_css question.body
        expect(page).to have_content('edited question')
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit somebody elses question' do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
