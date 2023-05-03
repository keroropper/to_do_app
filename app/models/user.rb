class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tasks
  validates :name, presence: true, length: { maximum: 10 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id", #フォローする側の自分
                                  dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed #sourceは相手側(自分がフォローしているユーザー)

  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id", #フォローされる側の自分
                                  dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower #sourceは相手側(自分をフォローしているユーザー)

  # 自分が相手をフォローしているか
  def followed_by?(user)
    passive_relationships.find_by(follower_id: user.id).present?
  end

  def follow(other_user)
    followings << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

end
