class RenamePasswordDigestsInUsers < ActiveRecord::Migration[7.1]
  def change
     rename_column :users, :password_digests, :password_digest
  end
end
