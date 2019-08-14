require 'rails_helper'

feature 'Create answer', %q{
In order to answer asked questions
As an authenticated user
I want to be able to create answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit "questions/#{question.id}"
    fill_in 'Answer_to_question', with: 'test_answer'
    click_on 'Send answer'

    expect(page).to have_content 'Your answer was successfully added.'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit "questions/#{question.id}"
    fill_in 'Answer_to_question', with: 'test_answer'
    click_on 'Send answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
