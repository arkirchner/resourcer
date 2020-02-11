class CreateProjectMemberInvitations < ActiveRecord::Migration[6.0]
  def change
    create_table :project_member_invitations do |t|
      t.belongs_to :project_member, null: false, foreign_key: true
      t.belongs_to :invitation, null: false, foreign_key: true, index: false

      t.timestamps
    end

    add_index :project_member_invitations, :invitation_id, unique: true
  end
end
