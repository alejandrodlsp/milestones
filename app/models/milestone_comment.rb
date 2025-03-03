class MilestoneComment < ApplicationRecord
  belongs_to :milestone
  belongs_to :user

  validates :message, presence: true
end
