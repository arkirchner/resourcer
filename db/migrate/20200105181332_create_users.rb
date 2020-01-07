class CreateUsers < ActiveRecord::Migration[6.0]
  def up
    create_enum "user_providers", %w[github google]

    create_table :users do |t|
      t.enum :provider, as: "user_providers", null: false
      t.string :provider_id, null: false
      t.string :name, null: false
      t.string :email, null: false, default: ""

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, %i[provider_id provider], unique: true
  end

  def down
    remove_index :users, :email, unique: true
    remove_index :users, %i[provider_id provider], unique: true

    drop_table :users

    drop_enum "user_providers"
  end
end
