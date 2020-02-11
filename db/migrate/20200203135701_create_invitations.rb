class CreateInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :invitations do |t|
      t.string :note, null: false, default: ""
      t.string :token, null: false, default: ""
      t.belongs_to :project_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
