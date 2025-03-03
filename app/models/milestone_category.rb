class MilestoneCategory < ApplicationRecord
  belongs_to :milestone
  belongs_to :category
end
