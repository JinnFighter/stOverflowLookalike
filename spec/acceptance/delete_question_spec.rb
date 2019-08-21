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
    sign_in(question.user)

    visit "questions/#{question.id}"
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted.'
  end

  scenario 'Authenticated user tries to delete somebody elses question' do
    sign_in(user)

    visit "questions/#{other_question.id}"
    click_on 'Delete question'

    expect(page).to have_content "You can\'\ t delete questions you haven\'\ t created."
  end

  scenario 'Non-Authenticated user tries to delete somebody elses question' do
    visit "questions/#{question.id}"
    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
