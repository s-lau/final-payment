class EventMailer < ActionMailer::Base
  default :from => "notifications@chargeback.com"

  def event_closed_mail (event)
    @event = event
    mail(:to => event.owner.email,
         :bcc => event.participants.pluck(:email), 
         :subject => "Billing for #{event.name}",
         :template_path => "mails",
         :template_name => "event_closed")
  end
end
