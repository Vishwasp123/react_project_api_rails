class CreateBlacklistedTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :token
      t.datetime :exp

      t.timestamps
    end
    add_index :blacklisted_tokens, :token
  end
end
