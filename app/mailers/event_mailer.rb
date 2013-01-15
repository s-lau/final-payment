class EventMailer < ActionMailer::Base
  default :from => "notifications@chargeback.com"

  def event_closed_mail (user, event)
    @user = user
    @event = event
    mail(:to => event.participants.all.map(&:email), 
         :subject => "Billing for #{event.name}",
         :template_path => "mails",
         :template_name => "event_closed")
  end


end
