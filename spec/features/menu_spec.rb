# frozen_string_literal: true

require 'rails_helper'

feature 'Menu', :js do
  context 'create date and login' do
    before(:each) do
      @user = create(:user)
      @tag1 = create(:tag, user: @user)
      @tag2 = create(:tag, user: @user)
      @task1 = create(:task, user: @user, tag: @tag1)
      @task2 = create(:task, user: @user, tag: @tag2)
      @task3 = create(:task, user: @user, tag: @tag2)
      visit root_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end
    scenario 'have tag All Tasks' do
      expect(current_path).to eq root_path
      click_link_or_button 'Всі завдання'
      expect(current_path).to eq tasks_path
    end
    scenario 'have tag New Tag' do
      click_link_or_button 'Нова вкладка'
      expect(current_path).to eq new_tag_path
    end
    scenario 'have tag All Tags' do
      click_link_or_button 'Всі вкладки'
      expect(current_path).to eq tags_path
    end
    scenario 'right count tasks on lable tags in menu' do
      expect(page).to have_content("Всі завдання (#{Task.count})")
      expect(page).to have_content("#{@tag1.name} (#{@tag1.tasks.count})")
      expect(page).to have_content("#{@tag2.name} (#{@tag2.tasks.count})")
    end
    scenario 'right count tasks after change tag second task' do
      visit edit_task_path(@task2)
      page.select @tag1.name, :from => 'task[tag_id]'
      click_button 'Зберегти'
      expect(page).to have_content("Всі завдання (#{Task.count})")
      expect(page).to have_content("#{@tag1.name} (2)")
      expect(page).to have_content("#{@tag2.name} (1)")
    end
    scenario 'label of tag without tasks will show zero' do
      page.find(:css, "#delete_task_#{@task1.id}").click
      page.driver.browser.switch_to.alert.accept
      sleep 0.1
      expect(page).to have_content("#{@tag1.name} (0)")
    end
  end
end
