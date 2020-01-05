class Project < ApplicationRecord
  before_validation :upcase_key

  has_many :issues

  validates :name, presence: true
  validates :key,
            length: { is: 3 }, format: { with: /\A[A-Z]+\z/ }, uniqueness: true

  private

  def upcase_key
    key.upcase!
  end
end
