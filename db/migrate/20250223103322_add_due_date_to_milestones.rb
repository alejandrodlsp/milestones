class AddDueDateToMilestones < ActiveRecord::Migration[8.0]
  def change
    add_column :milestones, :due_date, :datetime, null: false
  end
end
