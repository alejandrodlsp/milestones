class Milestone < ApplicationRecord
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
  #validates :image, presence: true
  validates :due_date, presence: true

  scope :external_only, -> { where(private: false, user_id: nil) }
  scope :public_only, -> { where(private: false) }

  after_commit :clear_popular_milestones_cache, on: [:create]

  def self.accesible_by_user(user)
    where("user_id = ? OR private = ?", user.id, false)
  end

  # Clone a public milestone for a user
  def clone_for_user(user)
    cloned_milestone = self.dup
    cloned_milestone.user = user
    cloned_milestone.original_milestone = self
    cloned_milestone.private = true # User's copy should be private
    cloned_milestone.save!
    
    # Clone associated checkpoints
    self.checkpoints.each do |checkpoint|
      cloned_milestone.checkpoints.create!(
        name: checkpoint.name,
        completed_at: nil
      )
    end

    cloned_milestone
  end

  private

  def clear_popular_milestones_cache
    Rails.cache.delete("popular_milestones")
  end
end
