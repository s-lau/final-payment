class EventMailer < ActionMailer::Base
  default :from => "notifications@chargeback.com", :template_path => "mails"

  def event_closed_mail (user, event)
    @user = user
    @event = event
    mail(:to => event.participants.pluck(:email), 
         :subject => "Billing for #{event.name}",
         :template_name => "event_closed")
  end
  
  def user_message(event, from, to, message)
    @event = event
    @from = from
    @to = to
    @message = message
    mail to: @to.email, reply_to: @from.email, subject: t('event_mailer.user_message.subject', username: @from.username) do |format|
      format.text { render text: t('event_mailer.user_message.body', event: @event.name, message: @message, username: @from.username) }
    end
  end


end
