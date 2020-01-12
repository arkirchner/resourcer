Rails.application.config.action_view.field_error_proc =
  Proc.new { |html_tag| html_tag }
