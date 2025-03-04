class AddOriginalMilestoneToMilestones < ActiveRecord::Migration[7.0]
  def change
    add_reference :milestones, :original_milestone, foreign_key: { to_table: :milestones }, index: true
  end
end
