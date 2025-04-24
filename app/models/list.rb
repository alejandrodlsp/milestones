class List < ApplicationRecord
  belongs_to :user, optional: true

  has_many :milestone_lists, dependent: :destroy
  has_many :milestones, through: :milestone_lists

  # Validations for title and description
  validates :name, presence: true, length: { minimum: 3, message: "must be at least 3 characters long" }
  validates :description, presence: true, length: { minimum: 5, message: "must be at least 5 characters long" }

  scope :public_only, -> { where(user_id: nil) }
end