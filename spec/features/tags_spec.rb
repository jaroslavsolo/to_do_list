# frozen_string_literal: true

require 'rails_helper'

feature 'Tags', :js do
  context 'create user and login' do
    before(:each) do
      @user = create(:user)
      visit root_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end
    scenario 'create tag' do
      expect(current_path).to eq root_path
      expect(Tag.count).to eq(0)
      click_link_or_button 'Нова вкладка'
      fill_in 'tag[name]', with: 'new_tag'
      click_button 'Зберегти'
      expect(current_path).to eq tags_path
      expect(Tag.count).to eq(1)
    end
    scenario 'can`t create tag without name' do
      click_link_or_button 'Нова вкладка'
      click_button 'Зберегти'
      expect(current_path).to eq new_tag_path
      expect(Tag.count).to eq(0)
    end
    context 'create tag' do
      before(:each) do
        @tag = create(:tag, user: @user)
        visit tags_path
      end
      scenario 'can update tag' do
        page.find(:css, "#edit_tag_#{@tag.id}").click
        expect(current_path).to eq edit_tag_path(@tag)
        fill_in 'tag[name]', with: 'new_tag'
        click_button 'Зберегти'
        expect(current_path).to eq tags_path
        @tag.reload
        expect(@tag.name).to eq('new_tag')
      end
      scenario 'can`t update tag without name' do
        old_name = @tag.name
        page.find(:css, "#edit_tag_#{@tag.id}").click
        expect(current_path).to eq edit_tag_path(@tag)
        fill_in 'tag[name]', with: ''
        click_button 'Зберегти'
        expect(current_path).to eq edit_tag_path(@tag)
        @tag.reload
        expect(@tag.name).to eq(old_name)
      end
      scenario 'can delete tag' do
        tag_name = @tag.name
        page.find(:css, "#delete_tag_#{@tag.id}").click
        expect(page.driver.browser.switch_to.alert.text).to eq('Ви впевнені?')
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq tags_path
        sleep 0.1
        expect(Tag.count).to eq(0)
        expect(page).to_not have_content(tag_name)
      end
    end
  end
end
