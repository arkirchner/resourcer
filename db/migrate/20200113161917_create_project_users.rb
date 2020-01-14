class CreateProjectUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_users do |t|
      t.belongs_to :user, null: false, foreign_key: true, index: false
      t.belongs_to :project, null: false, foreign_key: true, index: false
      t.boolean :owner, null: false, default: false

      t.timestamps
    end

    add_index :project_users, %i[user_id project_id], unique: true
  end
end
