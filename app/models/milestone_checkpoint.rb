class MilestoneCheckpoint < ApplicationRecord
  belongs_to :milestone

  validates :name, presence: true
end
