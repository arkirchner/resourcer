class Project < ApplicationRecord
  before_validation :upcase_key

  has_many :issues, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :key,
            length: { is: 3 }, format: { with: /\A[A-Z]+\z/ }, uniqueness: true

  private

  def upcase_key
    key.upcase!
  end
end
