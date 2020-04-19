class Project < ApplicationRecord
  before_validation :upcase_key

  has_many :issues, dependent: :restrict_with_exception
  has_many :histories, -> { order(changed_at: :desc) }, through: :issues
  has_many :project_members, dependent: :restrict_with_exception
  has_many :members, through: :project_members
  has_many :invitations, through: :project_members

  scope :with_member,
        lambda { |member|
          joins(:project_members).merge(ProjectMember.where(member_id: member))
        }

  validates :name, presence: true
  validates :key,
            length: { is: 3 }, format: { with: /\A[A-Z]+\z/ }

  def save_with_inital_member(member)
    return false if invalid?

    ProjectMember.new(member: member, project: self, owner: true).save
  end

  private

  def upcase_key
    return unless key

    key.upcase!
  end
end
