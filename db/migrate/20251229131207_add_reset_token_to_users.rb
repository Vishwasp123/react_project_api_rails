class AddResetTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_token, :string
  end
end
