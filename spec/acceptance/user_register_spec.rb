require_relative 'acceptance_helper'

feature 'User register', %q{
  In order to be able to ask questions and/or provide answers
  As user
  I want to be able to register
 } do

   given(:user) { create(:user) }
   scenario 'Non-registered user registers' do
     visit 'users/sign_up'

     fill_in 'Email', with: 'new_user@test.com'
     fill_in 'Password', with: '12345678'
     fill_in 'Password confirmation', with: '12345678'
     click_on 'Sign up'

     expect(page).to have_content 'Welcome! You have signed up successfully.'
   end
 end
