require_relative 'acceptance_helper'

feature 'User sign out', %q{
In order to be able to change accounts
As a registered and an authenticated user
I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user signs out' do
    visit questions_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
