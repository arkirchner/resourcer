require "test_helper"

class ProjectMemberTest < ActiveSupport::TestCase
  test "the last owner for a project can not be deleted" do
    project_member = FactoryBot.create :project_member, owner: true

    error =
      assert_raises RuntimeError do
        project_member.destroy
      end

    assert_equal error.message, "The last owner can not be removed!"
    assert ProjectMember.exists?(id: project_member.id)
  end
end
