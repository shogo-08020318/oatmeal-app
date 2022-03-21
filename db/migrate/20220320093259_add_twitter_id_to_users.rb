class AddTwitterIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :twitter_id, :string
  end
end
