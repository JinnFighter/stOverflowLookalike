require_relative('acceptance_helper')

feature 'Answer editing', %q{
In order to fix mistake
As an author of answer
I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees edit link' do
      within '#answers' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'tries to edit his answer', js: true do
      click_link 'Edit'
      wait_for_ajax
      within '#answers' do

        fill_in 'edit_answer_body', with: 'edited answer'

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit other users answer', js: true do
      expect(page).to_not have_link("#edit-answer-link-#{answer.id}")
    end
  end
end
