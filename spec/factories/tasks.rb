FactoryBot.define do
  factory :task do
    title { "MyText" }
    completed { false }
    user
  end

end
