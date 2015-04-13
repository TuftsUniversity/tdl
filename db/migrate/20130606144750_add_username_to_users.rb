class AddUsernameToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :email, :username 
  end
end
