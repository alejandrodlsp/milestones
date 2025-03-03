class AddUserFields < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :last_name, :string, null: false

    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    add_column :users, :last_login, :datetime
    add_column :users, :last_login_attempt, :datetime
    add_column :users, :loging_attempts, :integer, default: 0
  end
end
