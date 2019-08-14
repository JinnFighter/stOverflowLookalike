require 'rails_helper'

feature 'View question and answers to it', %q{
In order to provide useful answer to question
As an authenticated user
I want to be able to view question and given answers
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user views question and answers to it' do
    sign_in(user)

    visit "questions/#{question.id}"

    expect(page).to have_css('div#question_data').and have_css 'div#answers'
  end

  scenario 'Non-authenticated user tries to view question and answers to it' do
    visit "questions/#{question.id}"

    expect(page).to have_css('div#question_data').and have_css 'div#answers'
  end
end
