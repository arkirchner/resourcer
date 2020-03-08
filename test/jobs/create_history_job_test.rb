require 'test_helper'

class CreateHistoryJobTest < ActiveJob::TestCase
  test "perform" do
    create_for_request = Minitest::Mock.new
    create_for_request.expect :call, nil, ["request_uuid"]

    History.stub :create_for_request, create_for_request do
      CreateHistoryJob.new.perform("request_uuid")
    end
  end
end
