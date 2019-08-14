require 'rails_helper'

feature 'View questions list', %q{
  In order to answer somebody's question
  As an authenticated user
  I want to be able to view list of questions
 } do
   given(:user) { create(:user) }
   given(:questions) { Questions.all }
   scenario 'Authenticated user views questions list' do
     sign_in(user)

     visit questions_path

     expect(page).to have_css 'div.questions_list'
   end

   scenario 'Non-authenticated user tries to view questions list' do
     visit questions_path

     expect(page).to have_css 'div.questions_list'
   end
 end
