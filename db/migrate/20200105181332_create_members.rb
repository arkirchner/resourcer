class CreateMembers < ActiveRecord::Migration[6.0]
  def up
    create_enum "member_providers", %w[github google]

    create_table :members do |t|
      t.enum :provider, as: "member_providers", null: false
      t.string :provider_id, null: false
      t.string :name, null: false
      t.string :email, null: false, default: ""

      t.timestamps
    end

    add_index :members, :email, unique: true
    add_index :members, %i[provider_id provider], unique: true
  end

  def down
    remove_index :members, :email, unique: true
    remove_index :members, %i[provider_id provider], unique: true

    drop_table :members

    drop_enum "members_providers"
  end
end
