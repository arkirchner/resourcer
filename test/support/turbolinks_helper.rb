module TurbolinksHelper
  def wait_for_turbolinks
    has_css?('.turbolinks-progress-bar', visible: true)
    has_no_css?('.turbolinks-progress-bar')
  end
end
