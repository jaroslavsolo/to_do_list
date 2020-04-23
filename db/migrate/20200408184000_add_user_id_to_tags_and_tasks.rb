class AddUserIdToTagsAndTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user_id , :integer
    add_column :tags, :user_id , :integer
  end
end
