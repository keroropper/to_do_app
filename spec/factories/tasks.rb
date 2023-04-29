FactoryBot.define do
  factory :task do
    title { "MyText" }
    completed { false }
    user
  end
   
   trait :past_task do
    sequence(:title) { |n| "#{n}日前のタスク" }
    completed { false }
    user
    sequence(:created_at) { |n| n.days.ago }
   end
end
