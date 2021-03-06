require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "should not save a project without subject" do
    project = FactoryBot.build :project, name: nil
    assert_not project.save, "Saved the project without a name"
  end

  test "should not save a project with key with incorrect length" do
    short_project = FactoryBot.build :project, key: "AA"
    assert_not short_project.save, "Saved the project without 2 letter key"

    long_project = FactoryBot.build :project, key: "AAAA"
    assert_not long_project.save, "Saved the project without 4 letter key"
  end

  test "should only allow letters and numbers" do
    whitespace = FactoryBot.build :project, key: "A A"
    assert_not whitespace.save, "Saved the project with a whitespace"

    special_character = FactoryBot.build :project, key: "AA+"
    assert_not special_character.save,
               "Saved the project with a special character"
  end

  test "key with down case values are upcased" do
    project = FactoryBot.build :project, key: "abc"
    project.valid?

    assert_equal project.key, "ABC", "Key values have not been upcased"
  end

  test ".with_member, return projects related to the member" do
    member = FactoryBot.create :member

    first_assigned_project = FactoryBot.create :project
    second_assigned_project = FactoryBot.create :project
    unrelated_project = FactoryBot.create :project

    ProjectMember.create(project: first_assigned_project, member: member)
    ProjectMember.create(project: second_assigned_project, member: member)

    assert_includes Project.with_member(member), first_assigned_project
    assert_includes Project.with_member(member), second_assigned_project
    assert_not_includes Project.with_member(member), unrelated_project
  end

  test "#members, lists all project members" do
    project = FactoryBot.create :project
    members = FactoryBot.create_list :member, 2

    project.members << members

    assert_equal project.reload.members, members
  end

  class CreateWithInitalMember < ActiveSupport::TestCase
    test "creates the project with the inital member as owner" do
      member = FactoryBot.create :member
      project = Project.new(name: "Test Project", key: "TPK")
      project.save_with_inital_member(member)
      project_member = project.project_members.first

      assert_equal project_member.member, member
      assert project_member.owner
    end

    test "creates no project and project member with invalid project" do
      member = FactoryBot.create :member
      project = Project.new

      assert_difference %w[Project.count ProjectMember.count], 0 do
        project.save_with_inital_member(member)
      end
    end
  end
end
