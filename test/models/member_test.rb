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

    def github_auth_hash
      OmniAuth::AuthHash.new(
        provider: "github",
        uid: "123456",
        info: { name: "Github User", email: "github_member@example.com" },
      )
    end
  end

  class Assoziations < ActiveSupport::TestCase
    test "members associated to a project" do
      project = FactoryBot.create :project
      members = FactoryBot.create_list :member, 2
      other_member = FactoryBot.create :member

      members.each do |member|
        ProjectMember.create(project: project, member: member)
      end

      assert_equal Member.with_project(project), members
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

    test "it requires an email" do
      @member.email = ""
      assert_not @member.save
    end

    test "the email format must be valid" do
      @member.email = "@example.com"
      assert_not @member.save
    end
  end
end
