module ApplicationHelper
  def status_badge(status)
    case status.to_sym
    when :open
      tag.span "Open", class: "badge badge-warning"
    when :in_progess
      tag.span "In Progress", class: "badge badge-info"
    when :resolved
      tag.span "Resolved", class: "badge badge-success"
    when :in_progess
      tag.span "Closed", class: "badge badge-secondary"
    end
  end
end
