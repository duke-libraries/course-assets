class AddAttributesToUser < ActiveRecord::Migration

  def up
    change_table :users do |t|
      t.string :username, :default => "", :null => false
      t.index :username, :unique => true
      t.remove_index :name => "index_users_on_email"
      # re-create index on email w/o unique
      t.index :email
      t.string :first_name
      t.string :middle_name
      t.string :nickname
      t.string :last_name
    end
  end

  def down
    change_table :users do |t|
      t.remove :last_name
      t.remove :nickname
      t.remove :middle_name
      t.remove :first_name
      t.remove_index :email
      t.index ["email"], :name => "index_users_on_email", :unique => true
      t.remove :username
    end
  end

end
