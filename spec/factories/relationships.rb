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

def create_relationships 
  user = create(:user)
  10.times do 
    relation_user = create(:user)
    create(:following, follower: user, followed: relation_user )
    create(:follower, followed: user, follower: relation_user )
    # user = followings = 10,followers = 10
  end
  user
end


