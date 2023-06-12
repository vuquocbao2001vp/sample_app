module ApplicationHelper
  def full_title page_title
    base_title = t "layouts.title"
    page_title.empty? ? base_title : [page_title, base_title].join(" | ")
  end
end
