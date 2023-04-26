class Task < ApplicationRecord
  validate :validate_daily_task_limit, on: :create
  belongs_to :user
  validates :title, presence: true, length: { maximum: 25 }

  def validate_daily_task_limit
    if self.user.tasks.where("created_at >= ?", Date.today).count >= 10 
      errors.add(:base, "１日に追加できるタスクは10個までです")
    end
  end
end
