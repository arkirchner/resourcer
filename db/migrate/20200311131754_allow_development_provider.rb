class AllowDevelopmentProvider < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    if Rails.env.development?
      add_enum_value :member_providers, "developer"
    end
  end
end
