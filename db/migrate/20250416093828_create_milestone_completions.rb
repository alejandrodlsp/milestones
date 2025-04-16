class CreateMilestoneCompletions < ActiveRecord::Migration[8.0]
  def change
    create_table :milestone_completions do |t|
      t.references :milestone, null: false, foreign_key: true
      t.text :summary

      t.timestamps
    end
  end
end
