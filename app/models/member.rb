class Member < ApplicationRecord
  enum provider:
         if Rails.env.development?
           { github: "github", google: "google", developer: "developer" }
         else
           { github: "github", google: "google" }
         end

  has_many :project_members, dependent: :restrict_with_exception
  has_many :projects, through: :project_members
  has_many :assigned_issues, through: :project_members
  has_many :created_issues, through: :project_members

  scope :with_project,
        lambda { |project|
          joins(:project_members).merge(ProjectMember.where(project: project))
        }

  def self.find_or_create_from_auth_hash(auth_hash)
    provider_id, provider = auth_hash.values_at :uid, :provider

    find_or_initialize_by(provider_id: provider_id, provider: provider)
      .tap do |member|
      name, email, image = auth_hash.info.values_at :name, :email, :image

      member.attributes = {
        image_url: image || "", email: email || "", name: name
      }

      member.save!
    end
  end

  validates :provider_id, :name, presence: true
end
