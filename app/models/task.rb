class Task < ApplicationRecord
  belongs_to :tag
  belongs_to :user
  validates_presence_of :title, :body

  def change_status
    update(status: !status)
  end
end
