FactoryBot.define do
  factory :following, class: Relationship do
    follower_id { 1 }
    association :followed, factory: :user
  end
  factory :follower, class: Relationship do
    followed_id { 1 }
    association :follower, factory: :user
  end

end


