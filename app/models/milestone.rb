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
  accepts_nested_attributes_for :checkpoints, allow_destroy: true

  has_many :cloned_milestones, class_name: 'Milestone', foreign_key: 'original_milestone_id'

  validates :name, presence: true
  validates :description, presence: true
  validates :image, presence: true
  
  scope :active, -> { where(status: :active) }
  scope :external_only, -> { active.where(private: false, user_id: nil) }
  scope :public_only, -> { active.where(private: false) }
  scope :not_completed, -> { where(status: :active) }

  after_commit :clear_popular_milestones_cache, on: [:create]

  def self.accesible_by_user(user)
    friend_ids = user.all_friends.pluck(:id)
  
    where(
      "user_id = :user_id OR private = :public OR user_id IS NULL OR user_id IN (:friends)",
      user_id: user.id, public: false, friends: friend_ids, status: 0
    )
  end

  private

  def clear_popular_milestones_cache
    Rails.cache.delete("popular_milestones")
  end
end
