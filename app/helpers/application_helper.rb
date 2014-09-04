module ApplicationHelper

  def alert_messages
    AlertMessage.where(active: true)
  end

end
