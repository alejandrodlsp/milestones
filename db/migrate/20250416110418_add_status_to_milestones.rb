class AddStatusToMilestones < ActiveRecord::Migration[8.0]
  def change
    add_column :milestones, :status, :integer, default: 0, null: false
  end
end
