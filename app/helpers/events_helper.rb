module EventsHelper
  
  def compensation_link event, user
    if @event.is_owner? current_user
      action = event.balance_for_user_cents(user) < 0 ? :received : :sent
      if user != current_user && !user.payed_fair_share?(event, action)
        link_to t(action, scope: 'events.compensation'), compensate_event_path(user:user, a: action), class: 'btn', method: :post
      end
    elsif user == current_user
      action = event.balance_for_user_cents(user) > 0 ? :received : :sent
      unless current_user.payed_fair_share? event, action
        link_to t(action, scope: 'events.compensation'), compensate_event_path(a: action) , class: 'btn btn-warning', method: :post
      end
    end
  end
  
end
