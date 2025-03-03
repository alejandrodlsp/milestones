class CreateMilestoneLists < ActiveRecord::Migration[8.0]
  def change
    create_table :milestone_lists do |t|
      t.references :milestone, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
