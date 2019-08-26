require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to improve my answers
  As an authenticated user
  I want to be able to delete my answers
 } do
   given(:user) { create(:user) }
   given!(:question) { create(:question) }
   given!(:answer) { create :answer, question: question, user: user }
   given!(:other_answer) { create :answer, question: question }

   scenario 'Authenticated user deletes his answer' do
     sign_in(user)

     visit "questions/#{question.id}"
     within "#answers" do
     click_on "delete_answer_#{answer.id}"
   end
     expect(page).to have_content 'Your answer was successfully deleted.'
   end

   scenario 'Authenticated user tries to delete somebody elses answer' do
     sign_in(user)

     visit "questions/#{question.id}"
     expect(page).to_not have_button("delete_answer_#{other_answer.id}")
   end

   scenario 'Non-authenticated user tries to delete somebody elses answer' do
     visit "questions/#{question.id}"
     expect(page).to_not have_button("delete_answer_#{other_answer.id}")
   end
 end
