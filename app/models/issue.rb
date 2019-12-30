class Issue < ApplicationRecord
  belongs_to :project
  validates :subject, presence: true
end
