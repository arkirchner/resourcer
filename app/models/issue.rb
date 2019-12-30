class Issue < ApplicationRecord
  validates :subject, presence: true
end
