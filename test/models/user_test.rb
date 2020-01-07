require "test_helper"

module UserTest
  class FindOrCreateFromAuthHash < ActiveSupport::TestCase
    test "it creates a new user" do
      assert_changes -> { User.count }, "no user was created", from: 0, to: 1 do
        User.find_or_create_from_auth_hash(github_auth_hash)
      end
    end

    test "it finds an exsiting user" do
      User.find_or_create_from_auth_hash(github_auth_hash)

      assert_no_changes -> { User.count }, "the exsiting user was not returned" do
        User.find_or_create_from_auth_hash(github_auth_hash)
      end
    end

    def github_auth_hash
      OmniAuth::AuthHash.new(
        provider: "github",
        uid: "123456",
        info: { name: "Github User", email: "github_user@example.com" },
      )
    end
  end

  class Validations < ActiveSupport::TestCase
    setup do
      @user = FactoryBot.build :user
    end

    test "it requires a provider" do
      @user.provider = ""
      assert_raise(ActiveRecord::NotNullViolation) { @user.save }
    end

    test "it requires a valid provider" do
      assert_raise(ArgumentError) { @user.provider = "line" }
    end

    test "it requires a provider_id" do
      @user.provider_id = ""
      assert_not @user.save
    end

    test "it requires a name" do
      @user.name = ""
      assert_not @user.save
    end

    test "it requires an email" do
      @user.email = ""
      assert_not @user.save
    end

    test "the email format must be valid" do
      @user.email = "@example.com"
      assert_not @user.save
    end
  end
end
