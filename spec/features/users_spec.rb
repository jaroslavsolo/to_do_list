# frozen_string_literal: true

require 'rails_helper'

feature 'Users', :js do
  context 'log in, sign up, log out' do
    before(:each) do
      @user = create(:user)
      visit root_path
    end
    scenario 'do not access all tags' do
      expect(page).to have_content('Log in')
      expect(page).to have_content('Вкладки')
      expect(page).to_not have_content('Всі вкладки')
    end
    scenario 'Sign up' do
      click_link 'Sign up'
      expect(page).to have_content('Sign up')
      expect(current_path).to eq new_user_registration_path
      fill_in 'Email', with: 'user@gmail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
      expect(current_path).to eq root_path
    end
    scenario 'log in' do
      expect(current_path).to eq new_user_session_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
    end
    scenario 'sign out' do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
      expect(current_path).to eq root_path

      page.find(:css, "#sign_out").click
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content('Log in')
    end
    scenario 'header show user.email' do
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
      expect(current_path).to eq root_path
      expect(page).to have_content(@user.email)
    end
  end
end
