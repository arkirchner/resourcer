module ProjetcsHelper
  def sidebar_link_to(path, &html)
    link_class = current_page?(path) ? "nav-link active" : "nav-link"

    link_to capture(&html), path, class: link_class
  end
end
