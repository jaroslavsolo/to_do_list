# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    user
    tag
    sequence(:title) { |n| "task_title#{n}" }
    sequence(:body) { |n| "taask_body#{n}" }
  end
end
