class MilestoneList < ApplicationRecord
  belongs_to :milestone
  belongs_to :list
end
