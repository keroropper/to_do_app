FactoryBot.define do
  factory :task do
    title { "MyText" }
    completed { false }
    user
  end
   
   trait 'invalid' do
    title { "" }
    completed { false }
    user
   end
end
