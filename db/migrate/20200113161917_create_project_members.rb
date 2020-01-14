class CreateProjectMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :project_members do |t|
      t.belongs_to :member, null: false, foreign_key: true, index: false
      t.belongs_to :project, null: false, foreign_key: true, index: false
      t.boolean :owner, null: false, default: false

      t.timestamps
    end

    add_index :project_members, %i[member_id project_id], unique: true
  end
end
