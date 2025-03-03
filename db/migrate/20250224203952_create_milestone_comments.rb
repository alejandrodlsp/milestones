class CreateMilestoneComments < ActiveRecord::Migration[8.0]
  def change
    create_table :milestone_comments do |t|
      t.references :milestone, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :message

      t.timestamps
    end
  end
end
