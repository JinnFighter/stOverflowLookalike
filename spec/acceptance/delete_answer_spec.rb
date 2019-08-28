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

   scenario 'Non-authenticated user tries to delete somebody elses answer' do
     visit question_path(question)
     expect(page).to_not have_button("delete_answer_#{other_answer.id}")
   end

   describe 'Authenticated user' do
     before do
       sign_in(user)
       visit question_path(question)
     end

     scenario 'deletes his answer', js: true do
       within "#answers" do
         click_on "delete_answer_#{answer.id}"
       end

       expect(page).to_not have_css("answer_body_#{ answer.id }")
     end

     scenario 'tries to delete somebody elses answer' do
       expect(page).to_not have_button("delete_answer_#{ other_answer.id }")
     end
   end
 end
