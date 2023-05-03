class Relationship < ApplicationRecord
  belongs_to :followed, class_name: 'User' #active
  belongs_to :follower, class_name: 'User' #pussive
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
