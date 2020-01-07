class User < ApplicationRecord
  enum provider: { github: "github", google: "google" }

  def self.find_or_create_from_auth_hash(auth_hash)
    provider_id, provider = auth_hash.values_at :uid, :provider

    find_or_initialize_by(provider_id: provider_id, provider: provider).tap do |user|
      name, email = auth_hash.info.values_at :name, :email
      user.email = email
      user.name = name
      user.save!
    end
  end

  validates :provider_id, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
