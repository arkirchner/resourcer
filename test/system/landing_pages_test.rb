require "application_system_test_case"

class LandingPagesTest < ApplicationSystemTestCase
  test "a guest user can see the langing page" do
    visit root_path

    assert_text "Give Resourcer a try."
  end

  test "a guest user visiting a unauthorised path will be redirected" do
    visit dashboard_path

    assert_text "Give Resourcer a try."
  end

  test "a signed in user will be redirected to the dashboard" do
    sign_up_with_github
    visit root_path

    assert_text "My Issues"
  end
end
