# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@lviv.ua" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
