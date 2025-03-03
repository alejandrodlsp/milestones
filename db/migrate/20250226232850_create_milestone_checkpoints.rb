class CreateMilestoneCheckpoints < ActiveRecord::Migration[8.0]
  def change
    create_table :milestone_checkpoints do |t|
      t.references :milestone, null: false, foreign_key: true
      t.string :name, null: false
      t.datetime :completed_at

      t.timestamps
    end
  end
end
