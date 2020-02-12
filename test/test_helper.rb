ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"

class ActiveSupport::TestCase # rubocop:disable Style/ClassAndModuleChildren
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  fixtures :all

  # Set @member and @require_id for paper_trail request scope
  def paper_trail_request(member:, request_id:)
    PaperTrail.request(
      { whodunnit: member.id, controller_info: { request_id: request_id } },
    ) { yield }
  end
end
