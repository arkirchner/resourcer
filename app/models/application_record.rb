class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_validation { @validated = true }

  def validated?
    @validated || false
  end
end
