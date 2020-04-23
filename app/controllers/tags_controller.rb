class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = tags
  end

  def show
    @tasks = @tag.tasks.order(id: :desc)
  end

  def new
    @tag = tags.new
  end

  def edit
  end

  def create
    @tag = tags.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_url, success: 'Tag was successfully created.' }
      else
        format.html { redirect_to new_tag_url }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tags_url, success: 'Tag was successfully updated.' }
      else
        format.html { redirect_to edit_tag_url(@tag) }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, success: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_tag
    @tag = tags.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name, :user_id)
  end

  def tags
    @tags ||= current_user.tags
  end
end
