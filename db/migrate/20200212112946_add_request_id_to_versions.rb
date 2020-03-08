class AddRequestIdToVersions < ActiveRecord::Migration[6.0]
  def change
    add_column :versions, :request_id, :uuid
    add_index :versions, :request_id
  end
end
