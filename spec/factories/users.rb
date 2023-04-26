FactoryBot.define do
  factory :user, aliases: [:owner] do
    name { "ryoya" }
    sequence(:email) { |n| "test-#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end

    trait :with_ten_tasks do
      after(:create) { |user| create_list(:task, 10, user: user) }
    end
end
