class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    enable_extension "pgcrypto" if Rails.env.development? || Rails.env.test?
    create_enum "history_events", %w[create destroy update]

    create_table :histories, id: :uuid do |t|
      t.belongs_to :issue, foreign_key: true
      t.belongs_to :member, foreign_key: true
      t.datetime :changed_at, null: false
      t.enum :event, as: "history_events", null: false

      t.timestamps
    end
  end
end
