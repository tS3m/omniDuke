class AddSessionIdToUser < ActiveRecord::Migration
  def change
      add_column :users, :session_id, :integer
  end
end
