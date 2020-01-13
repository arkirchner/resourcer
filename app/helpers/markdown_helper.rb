module MarkdownHelper
  def markdown_to_html(markdown)
    Markdown.to_html(markdown)
  end
end
