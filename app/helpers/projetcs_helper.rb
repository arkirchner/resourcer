module ProjetcsHelper
  def sidebar_link_to(path, &html)
    link_class = if current_page?(path)
                   "nav-link active"
                 else
                   "nav-link"
                 end

    link_to capture(&html), path, class: link_class
  end
end
