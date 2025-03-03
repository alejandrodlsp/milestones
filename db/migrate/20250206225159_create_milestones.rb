class CreateMilestones < ActiveRecord::Migration[8.0]
  def change
    create_table :milestones do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: true, foreign_key: true
      t.boolean :private, default: false

      t.timestamps
    end
  end
end
