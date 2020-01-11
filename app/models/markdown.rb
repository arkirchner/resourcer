class Markdown
  def self.to_html(markdown)
    Kramdown::Document.new(ApplicationController.helpers.sanitize(markdown)).to_html.html_safe
  end
end
