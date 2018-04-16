module ApplicationHelper
  def alert_class(type)
    types = {
      error: :alert,
      notice: :info,
    }
    types[type] || type
  end
end
