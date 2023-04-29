class Task < ApplicationRecord
  validate :validate_daily_task_limit, on: :create
  belongs_to :user
  validates :title, presence: true, length: { maximum: 25 }

  def validate_daily_task_limit
    if  user.present? && user.tasks.where("created_at >= ?", Date.today).count >= 10 
      errors.add(:base, "１日に追加できるタスクは10個までです")
    end
  end

  def self.past_task_of_days
    
  end

  def self.created_at_values
    # フォーマットを%Y-%m-%dにしてcreated_atを取得、distinctで重複を取り除いてgroupで("created_date")という名前にグループ化。
    # groupで指定するカラムは、selectで指定したエイリアスである必要がある。
    select("DATE_FORMAT(created_at, '%Y-%c-%d') AS created_date").where.not("DATE_FORMAT(created_at, '%Y-%c-%d') = ?", Date.today.strftime('%Y-%-m-%d')).distinct.group("created_date")
  end
end
