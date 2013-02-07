module EventsHelper
  
  def compensation_link event, user
    if @event.is_owner? current_user
      if user != current_user && !user.payed_fair_share?(event)
        link_to t(event.balance_for_user_cents(user) < 0 ? 'received' : 'sent', scope: 'events.compensation'), compensate_event_path(user:user), class: 'btn', method: :post
      end
    elsif user == current_user
      unless current_user.payed_fair_share? event
        link_to t(event.balance_for_user_cents(current_user) < 0 ? 'received' : 'sent', scope: 'events.compensation'), compensate_event_path , class: 'btn btn-warning', method: :post
      end
    end
  end
  
end
