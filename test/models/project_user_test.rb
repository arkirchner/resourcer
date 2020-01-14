require "test_helper"

class ProjectUserTest < ActiveSupport::TestCase
  test "the last owner for a project can not be deleted" do
    project_user = FactoryBot.create :project_user, owner: true

    error =
      assert_raises RuntimeError do
        project_user.destroy
      end

    assert_equal error.message, "The last owner can not be removed!"
    assert ProjectUser.exists?(id: project_user.id)
  end
end
