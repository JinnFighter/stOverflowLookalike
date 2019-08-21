require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to improve my answers
  As an authenticated user
  I want to be able to delete my answers
 } do
   given(:user) { create(:user) }
   given(:question) { create(:question, :with_answers_from_many_users, user: user) }
   given(:answer) { question.answers[0] }
   given(:other_answer) { question.answers[1] }

   scenario 'Authenticated user deletes his answer' do
     sign_in(user)

     visit "questions/#{question.id}"
     click_on "delete_answer_#{answer.id}"

     expect(page).to have_content 'Your answer was successfully deleted.'
   end

   scenario 'Authenticated user tries to delete somebody elses answer' do
     sign_in(user)

     visit "questions/#{question.id}"
     click_on "delete_answer_#{other_answer.id}"

     expect(page).to have_content "You can\'\ t delete answers you haven\'\ t created."
   end

   scenario 'Non-authenticated user tries to delete somebody elses answer' do
     visit "questions/#{question.id}"
     click_on "delete_answer_#{answer.id}"

     expect(page).to have_content 'You need to sign in or sign up before continuing.'
   end
 end
