class Category < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  has_many :milestone_categories, dependent: :destroy
  has_many :milestones, through: :milestone_categories
end
