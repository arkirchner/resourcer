class Member < ApplicationRecord
  enum provider: { github: "github", google: "google" }

  has_many :project_members

  scope :with_project,
        lambda { |project|
          joins(:project_members).merge(ProjectMember.where(project: project))
        }

  def self.find_or_create_from_auth_hash(auth_hash)
    provider_id, provider = auth_hash.values_at :uid, :provider

    find_or_initialize_by(provider_id: provider_id, provider: provider)
      .tap do |member|
      name, email = auth_hash.info.values_at :name, :email
      member.email = email
      member.name = name
      member.save!
    end
  end

  validates :provider_id, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
