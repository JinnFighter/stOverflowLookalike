require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
In order to illustrate my answer
As an answers author
I want to be able to attach files to my answers
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when leaves answer', js: true do
    fill_in 'Answer_to_question', with: 'My answer'

    click_on 'add file'

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Send answer'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds multiple files when leaves answer', js: true do
    fill_in 'Answer_to_question', with: 'My answer'

    click_on 'add file'
    within '.nested-fields:nth-of-type(2)' do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add file'
    within '.nested-fields:nth-of-type(3)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Send answer'

    within '#answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  scenario 'User leaves an empty file', js: true do
    fill_in 'Answer_to_question', with: 'My answer'

    click_on 'add file'

    click_on 'Send answer'

    expect(page).to have_content "Attachments file can't be blank"
  end
end
