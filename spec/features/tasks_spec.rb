# frozen_string_literal: true

require 'rails_helper'

feature 'Task', :js do
  context 'create user and login' do
    before(:each) do
      @user = create(:user)
      visit root_path
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log in'
    end
    scenario 'redirect to new_tag page if user have not tags' do
      expect(current_path).to eq root_path
      page.find(:css, "#new_task").click
      expect(current_path).to eq new_tag_path
    end
    context 'create two tags' do
      before(:each) do
        @tag1 = create(:tag, user: @user)
        @tag2 = create(:tag, user: @user)
      end
      scenario 'can create task' do
        page.find(:css, "#new_task").click
        expect(current_path).to eq new_task_path
        fill_in 'task[title]', with: 'new_task'
        fill_in 'task[body]', with: 'new_body'
        page.select @tag2.name, :from => 'task[tag_id]'
        click_button 'Зберегти'
        expect(current_path).to eq tag_path(@tag2)
        expect(@tag2.tasks.count).to eq(1)
      end
      scenario 'can`t create task without title' do
        page.find(:css, "#new_task").click
        expect(current_path).to eq new_task_path
        fill_in 'task[body]', with: 'new_body'
        page.select @tag2.name, :from => 'task[tag_id]'
        click_button 'Зберегти'
        expect(current_path).to eq new_task_path
        expect(Task.count).to eq(0)
      end
      scenario 'can`t create task without body' do
        page.find(:css, "#new_task").click
        expect(current_path).to eq new_task_path
        fill_in 'task[title]', with: 'new_task'
        page.select @tag2.name, :from => 'task[tag_id]'
        click_button 'Зберегти'
        expect(current_path).to eq new_task_path
        expect(Task.count).to eq(0)
      end
      context 'check update, delete and change status' do
        before(:each) do
          @task = create(:task, user: @user, tag: @tag1)
          visit tag_path(@tag1)
        end
        scenario 'can update' do
          page.find(:css, "#edit_task_#{@task.id}").click
          expect(current_path).to eq edit_task_path(@task)
          fill_in 'task[title]', with: 'new_task'
          fill_in 'task[body]', with: 'new_body'
          page.select @tag2.name, :from => 'task[tag_id]'
          click_button 'Зберегти'
          expect(current_path).to eq tag_path(@tag2)
          expect(@tag2.tasks.count).to eq(1)
          expect(@tag1.tasks.count).to eq(0)
          @task.reload
          expect(@task.title).to eq('new_task')
          expect(@task.body).to eq('new_body')
        end
        scenario 'can`t update without title' do
          page.find(:css, "#edit_task_#{@task.id}").click
          expect(current_path).to eq edit_task_path(@task)
          fill_in 'task[title]', with: ''
          fill_in 'task[body]', with: 'new_body'
          click_button 'Зберегти'
          expect(current_path).to eq edit_task_path(@task)
        end
        scenario 'can`t update without body' do
          page.find(:css, "#edit_task_#{@task.id}").click
          expect(current_path).to eq edit_task_path(@task)
          fill_in 'task[title]', with: 'new_title'
          fill_in 'task[body]', with: ''
          click_button 'Зберегти'
          expect(current_path).to eq edit_task_path(@task)
        end
        scenario 'can change tags' do
          page.find(:css, "#edit_task_#{@task.id}").click
          page.select @tag2.name, :from => 'task[tag_id]'
          click_button 'Зберегти'
          expect(current_path).to eq tag_path(@tag2)
          expect(@tag2.tasks.count).to eq(1)
          expect(@tag1.tasks.count).to eq(0)
        end
        scenario 'can delete' do
          page.find(:css, "#delete_task_#{@task.id}").click
          expect(page.driver.browser.switch_to.alert.text).to eq('Ви впевнені?')
          page.driver.browser.switch_to.alert.accept
          expect(current_path).to eq tag_path(@tag1)
          sleep 0.1
          expect(Task.count).to eq(0)
        end
        scenario 'change status' do
          expect(@task.status).to eq(false)
          page.find(:css, "#change_status_#{@task.id}").click
          @task.reload
          expect(@task.status).to eq(true)
        end
      end
    end
  end
end
