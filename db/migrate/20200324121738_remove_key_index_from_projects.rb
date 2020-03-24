class RemoveKeyIndexFromProjects < ActiveRecord::Migration[6.0]
  def up
    remove_index :projects, :key
  end

  def down
    add_index :projects, :key, unique: true
  end
end
