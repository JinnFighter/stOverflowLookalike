require_relative 'acceptance_helper'

feature 'Add files to question', %q{
In order to illustrate my question
As an author of question
I want to be able to attach files
 } do
   given(:user) { create(:user) }

   background do
     sign_in(user)
     visit new_question_path
   end

   scenario 'User adds file when asks a question', js: true do
     fill_in 'Title', with: 'Test question'
     fill_in 'Body', with: 'text text'
     click_on 'add file'

     wait_for_ajax

     attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

     click_on 'Create'

     expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
   end

   scenario 'User adds multiple files when asks a question', js: true do
     fill_in 'Title', with: 'Test question'
     fill_in 'Body', with: 'text text'

     click_on 'add file'

     within '.nested-fields:nth-of-type(1)' do
       attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
     end

     click_on 'add file'

     within '.nested-fields:nth-of-type(2)' do
       attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
     end

     click_on 'Create'

     expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
     expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
   end

   scenario 'User leaves an empty file', js: true do
     fill_in 'Title', with: 'Test question'
     fill_in 'Body', with: 'text text'
     click_on 'add file'

     click_on 'Create'

     within '.answer_errors' do
       expect(page).to have_content "Attachments file can't be blank."
     end
   end
 end
