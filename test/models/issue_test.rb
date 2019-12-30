require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  test "should not save issue without subject" do
    issue = FactoryBot.build :issue, subject: nil
    assert_not issue.save, "Saved the issue without a subject"
  end
end
