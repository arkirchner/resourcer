class RemoveEmailIndexFromMembers < ActiveRecord::Migration[6.0]
  def up
    remove_index :members, :email
  end

  def down
    add_index :members, :email, unique: true
  end
end
