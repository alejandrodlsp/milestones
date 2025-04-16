class Milestone < ApplicationRecord
  ACTIVE = 0
  COMPLETED = 1
  DELETED = 2

  STATUS_OPTIONS = {
    active: ACTIVE,
    completed: COMPLETED,
    deleted: DELETED
  }.freeze

  belongs_to :user, optional: true
  belongs_to :original_milestone, class_name: 'Milestone', optional: true
  
  has_one_attached :image
  has_many :milestone_categories, dependent: :destroy
  has_many :categories, through: :milestone_categories
  has_many :milestone_lists, dependent: :destroy
  has_many :lists, through: :milestone_lists
  has_many :comments, class_name: "MilestoneComment", foreign_key: "milestone_id", dependent: :destroy
  has_many :checkpoints, class_name: "MilestoneCheckpoint", foreign_key: "milestone_id", dependent: :destroy
  has_many :cloned_milestones, class_name: 'Milestone', foreign_key: 'original_milestone_id'

  validates :name, presence: true
  validates :description, presence: true
  validates :image, presence: true
  
  scope :external_only, -> { where(private: false, user_id: nil) }
  scope :public_only, -> { where(private: false) }
  scope :not_completed, -> { where(status: :active) }

  after_commit :clear_popular_milestones_cache, on: [:create]

  def self.accesible_by_user(user)
    where("user_id = ? OR private = ?", user.id, false).where(status: ACTIVE)
  end

  private

  def clear_popular_milestones_cache
    Rails.cache.delete("popular_milestones")
  end
end
