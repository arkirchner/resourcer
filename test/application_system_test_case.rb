require "test_helper"
require_relative "./support/auth_system_test_helper"
require_relative "./support/turbolinks_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include AuthSystemTestHelper
  include TurbolinksHelper

  driven_by :selenium,
            using: :headless_chrome,
            screen_size: [1_400, 1_400] do |driver_options|
    driver_options.add_argument("disable-dev-shm-usage")
  end

  def teardown
    super
    clear_omni_auth_mock
  end
end
