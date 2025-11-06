begin
  require "will_paginate"
  require "will_paginate/view_helpers/action_view"
rescue LoadError
  # nếu gem chưa cài, tránh crash server
end

module TailwindPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    def container_attributes
      { class: "flex justify-center gap-2 items-center mt-6 space-x-1" }
    end

    def page_number(page)
      if page == current_page 
        tag(:span, page, class: "px-3 py-1 bg-blue-600 text-white rounded-md")
      else
        link(page, page, class: "px-3 py-1 border rounded-md text-gray-700 hover:bg-gray-100")
      end
    end

    def previous_or_next_page(page, text, classname)
      if page
        link(text, page, class: "px-3 py-1 border rounded-md text-gray-700 hover:bg-gray-100")
      else
        tag(:span, text, class: "px-3 py-1 border rounded-md text-gray-400 cursor-not-allowed")
      end
    end

    def gap
      tag(:span, "…", class: "px-3 py-1 text-gray-400")
    end
  end
end
