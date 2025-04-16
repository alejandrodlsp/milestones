class MilestoneCompletion < ApplicationRecord
  belongs_to :milestone

  has_many_attached :images
  validates :summary, presence: true
end
