class TasksController < ApplicationController
  before_action :set_task, only: [:edit, :update, :destroy, :change_status]
  before_action :set_tag, only: [:edit, :update, :create, :destroy, :change_status]

  def index
    @tags = tags
    @tasks = tasks
  end

  def new
    redirect_to new_tag_path if current_user.tags.count == 0
    @tags = tags
    @task = tasks.new
  end

  def edit
    @tags = tags
  end

  def create
    @task = tasks.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @tag, success: 'Task was successfully created.' }
      else
        @tags = tags
        format.html { redirect_to new_task_path }
      end
    end
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @tag, success: 'Tag was successfully updated.' }
      else
        @tags = tags
        format.html { redirect_to edit_task_path(@task) }
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @tag, success: 'Tag was successfully destroyed.' }
    end
  end

  def change_status
    @task.change_status
    redirect_to @tag
  end

  private
  def set_tag
    if ["create", "update"].include?(params[:action])
      @tag = tags.find(params[:task][:tag_id])
    else
      @tag = tags.find(@task.tag_id)
    end
  end

  def set_task
    @task = tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :body, :status, :tag_id, :user_id)
  end

  def tasks
    current_user.tasks
  end

  def tags
    current_user.tags
  end
end
