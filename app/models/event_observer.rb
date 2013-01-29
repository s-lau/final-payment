class EventObserver < ActiveRecord::Observer
  def after_close event 
    EventMailer.event_closed_mail(event).deliver
  end
end
