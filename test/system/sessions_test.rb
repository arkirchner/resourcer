require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "visitor can sign up with Github" do
    sign_up_with_github

    assert_text "Hello Github User"
    assert_text "My Issues"
  end

  test "when the member logs out he will be redirected to the top page" do
    sign_up_with_github
    click_on "Github User"
    click_on "Sign Out"

    assert_text "Goodbye Github User"
    assert_text "Give Resourcer a try."
  end
end
