require_relative 'acceptance_helper'

feature 'Delete question', %q{
In order to remove mistakes in questions
As an authenticated user
I want to be able to delete questions
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question) }

  scenario 'Authenticated user deletes his question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'Authenticated user tries to delete somebody elses question' do
    sign_in(user)

    visit question_path(other_question)

    expect(page).to_not have_button('Delete question')
  end

  scenario 'Non-Authenticated user tries to delete somebody elses question' do
    visit question_path(question)

    expect(page).to_not have_button('Delete question')
  end
end
