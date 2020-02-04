require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  class AcceptTest < ActiveSupport::TestCase
    test "accepts a valid inviation" do
      invitation = FactoryBot.create :invitation
      member = FactoryBot.create :member

      Invitation.accept(invitation.token, member)
      assert_includes member.projects, invitation.project
    end

    test "rejects a expired validation" do
      freeze_time do
        invitation = FactoryBot.create :invitation
        member = FactoryBot.create :member

        travel 7.days

        assert_no_changes "ProjectMember.count" do
          assert_not Invitation.accept(invitation.token, member)
        end
      end
    end

    test "a invitation can only acceted once" do
      invitation = FactoryBot.create :invitation
      Invitation.accept(invitation.token, FactoryBot.create(:member))

      second_member = FactoryBot.create(:member)

      assert_no_changes "ProjectMember.count" do
        assert_not Invitation.accept(invitation.token, second_member)
      end
    end
  end

  test "token, encypts the invitation identifire with id and exparation" do
    invitation = FactoryBot.create :invitation

    generate = Minitest::Mock.new
    generate.expect :call,
                    "token-xzy",
                    [invitation.id, { expires_at: invitation.invalid_at }]

    Invitation.verifier.stub :generate, generate do
      invitation.token
    end

    assert generate.verify, "the identifire is not encrypted correctly"
  end
end
