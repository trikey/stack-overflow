module ApplicationHelper
  def alert_class(type)
    types = {
      error: :alert,
      notice: :info,
    }
    types[type] || type
  end

  def vote_link(object, vote_type)
    options = {
        remote: true,
        method: :patch,
        data: { type: :json },
        class: "vote_#{vote_type}"
    }

    link_to(polymorphic_path(["vote_#{vote_type}", object]), options) do
      content_tag(:i, vote_type, class: "glyphicon glyphicon-chevron-#{vote_type}", aria: { hidden: true })
    end.html_safe
  end
end
