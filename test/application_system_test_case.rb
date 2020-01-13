require "test_helper"
require_relative "./support/auth_system_test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include AuthSystemTestHelper
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400] do |driver_options|
    driver_options.add_argument("disable-dev-shm-usage")
  end

  def setup
    super
    mock_omin_auth_providers
  end

  def teardown
    super
    clear_omni_auth_mock
  end
end
