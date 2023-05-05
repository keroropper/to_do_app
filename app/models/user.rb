class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tasks
  has_one_attached :image
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
  before_create :default_image

  # 自分が相手をフォローしているか
  def followed_by?(user)
    active_relationships.find_by(followed_id: user.id).present?
  end

  def follow(other_user)
    followings << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def profile(size)
    if image.attached?
      image.variant(resize: "#{size}x#{size}^", gravity: "center", extent: "#{size}x#{size}", background: "#FFF").processed
    end
  end

  def attach_default 
    file = File.open(Rails.root.join('public', 'profiles', 'default.png'))
    blob = ActiveStorage::Blob.create_after_upload!(io: file, filename: 'default.png', content_type: 'image/png')
    image.attach(blob)
  end

  def attached_default_image?
    image.blob.filename.to_s == 'default.png'
  end

  private

    def default_image
      unless image.attached?
        image.attach(io: File.open(Rails.root.join('public', 'profiles', 'default.png')), filename: 'default.png', content_type: 'image/png')
      end
    end

end
