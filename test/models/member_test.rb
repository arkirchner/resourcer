require "test_helper"

module MemberTest
  class FindOrCreateFromAuthHash < ActiveSupport::TestCase
    test "it creates a new member" do
      assert_changes "Member.count", "no member was created", from: 0, to: 1 do
        Member.find_or_create_from_auth_hash(github_auth_hash)
      end
    end

    test "it finds an exsiting member" do
      Member.find_or_create_from_auth_hash(github_auth_hash)

      assert_no_changes -> { Member.count },
                        "the exsiting member was not returned" do
        Member.find_or_create_from_auth_hash(github_auth_hash)
      end
    end

    test "it saves optional oauth provider information" do
      auth_hash =
        OmniAuth::AuthHash.new(
          provider: "github",
          uid: "123456",
          info: {
            name: "Github User",
            email: "mail@example.com",
            image: "https://dummyimage.com/600x400/000/fff",
          },
        )

      member = Member.find_or_create_from_auth_hash(auth_hash)

      assert_equal member.email, "mail@example.com"
      assert_equal member.image_url, "https://dummyimage.com/600x400/000/fff"
    end

    def github_auth_hash
      OmniAuth::AuthHash.new(
        provider: "github", uid: "123456", info: { name: "Github User" },
      )
    end
  end

  class Assoziations < ActiveSupport::TestCase
    test "#assigned_issues" do
      project_member = FactoryBot.create :project_member
      assigned_issues =
        FactoryBot.create_list :issue,
                               2,
                               project: project_member.project,
                               assignee: project_member

      other_member =
        FactoryBot.create(:project_member, project: project_member.project)
      other_issue =
        FactoryBot.create :issue,
                          project: project_member.project, assignee: other_member

      assert_equal project_member.assigned_issues, assigned_issues
      assert_not_includes project_member.assigned_issues, [other_issue]
    end

    test "#created_issues" do
      project_member = FactoryBot.create :project_member
      assigned_issues =
        FactoryBot.create_list :issue,
                               2,
                               project: project_member.project,
                               creator: project_member

      other_member =
        FactoryBot.create(:project_member, project: project_member.project)
      other_issue =
        FactoryBot.create :issue,
                          project: project_member.project, creator: other_member

      assert_equal project_member.created_issues, assigned_issues
      assert_not_includes project_member.created_issues, [other_issue]
    end

    test "members associated to a project" do
      project = FactoryBot.create :project
      members = FactoryBot.create_list :member, 2
      other_member = FactoryBot.create :member

      members.each do |member|
        ProjectMember.create(project: project, member: member)
      end

      assert_equal Member.with_project(project), members
      assert_not_includes Member.with_project(project), other_member
    end
  end

  class Validations < ActiveSupport::TestCase
    setup { @member = FactoryBot.build :member }

    test "it requires a provider" do
      @member.provider = ""
      assert_raise(ActiveRecord::NotNullViolation) { @member.save }
    end

    test "it requires a valid provider" do
      assert_raise(ArgumentError) { @member.provider = "line" }
    end

    test "it requires a provider_id" do
      @member.provider_id = ""
      assert_not @member.save
    end

    test "it requires a name" do
      @member.name = ""
      assert_not @member.save
    end
  end
end
