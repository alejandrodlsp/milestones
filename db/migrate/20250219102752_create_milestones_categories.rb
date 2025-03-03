class CreateMilestonesCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :milestone_categories do |t|
      t.references :milestone, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
