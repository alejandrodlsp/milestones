class Milestone < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :milestone_categories, dependent: :destroy
  has_many :categories, through: :milestone_categories

  has_many :milestone_lists, dependent: :destroy
  has_many :lists, through: :milestone_lists

  has_many :comments, class_name: 'MilestoneComment', foreign_key: 'milestone_id', dependent: :destroy
  has_many :checkpoints, class_name: 'MilestoneCheckpoint', foreign_key: 'milestone_id', dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :image, presence: true
  validates :due_date, presence: true

  scope :external_only, -> { where(private: false, user_id: nil) }
  scope :public_only, -> { where(private: false) }

  def self.accesible_by_user(user)
    where("user_id = ? OR private = ?", user.id, false)
  end
end
