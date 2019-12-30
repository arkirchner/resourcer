class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :key, null: false, length: 3

      t.timestamps
    end

    add_index :projects, :key, unique: true
  end
end
