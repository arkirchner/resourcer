require 'test_helper'

class MarkdownTest < ActiveSupport::TestCase
  markdown = "# Heading\n---\n__Advertisement__\n"

  test "#to_html, markdown can be converted to html" do
    html = "<h1 id=\"heading\">Heading</h1>\n<hr />\n<p><strong>Advertisement</strong></p>\n"

    assert_equal Markdown.to_html(markdown), html
  end

  test "#to_html, markdown is converted to safe html" do
    assert Markdown.to_html(markdown).html_safe?
  end
end
