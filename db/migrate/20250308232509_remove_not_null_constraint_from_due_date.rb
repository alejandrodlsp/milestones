class RemoveNotNullConstraintFromDueDate < ActiveRecord::Migration[8.0]
  def change
    change_column_null :milestones, :due_date, true
  end
end
