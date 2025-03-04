class List < ApplicationRecord
  belongs_to :user

  has_many :milestone_lists, dependent: :destroy
  has_many :milestones, through: :milestone_lists
end
