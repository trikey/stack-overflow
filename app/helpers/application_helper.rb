module ApplicationHelper
  def alert_class(type)
    case type
    when 'error' then 'alert'
    when 'notice' then 'info'
    else type
    end
  end
end
