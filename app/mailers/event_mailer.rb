class EventMailer < ActionMailer::Base
  default :from => "notifications@chargeback.com",
          :host => "http://www.chargeback.com",
          :controller => "events",
          :only_path => false

  def event_closed_mail (user, event)
    @user = user
    @event = event
    mail(:to => event.participants.all.map(&:email), 
         :subject => "Event: #{event.name} closed",
         :template_path => "mails",
         :template_name => "event_closed")
  end


end
