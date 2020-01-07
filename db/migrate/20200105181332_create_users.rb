class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :provider_id, null: false
      t.string :provider, null: false
      t.string :name, null: false
      t.string :email, null: false, default: ""

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, %i[provider_id provider], unique: true
  end
end
