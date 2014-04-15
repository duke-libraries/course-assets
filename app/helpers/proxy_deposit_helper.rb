module ProxyDepositHelper
  
  def on_behalf_of_selector
    options = []
    current_user.can_make_deposits_for.each do |user|
      options << [ user.to_s, user.user_key ]
    end
    options_for_select(options)
  end
  
end