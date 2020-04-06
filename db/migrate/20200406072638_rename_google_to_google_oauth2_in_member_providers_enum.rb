class RenameGoogleToGoogleOauth2InMemberProvidersEnum < ActiveRecord::Migration[6.0]
  def change
    rename_enum_value "member_providers", from: "google", to: "google_oauth2"
  end
end
