class EventCompensation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :event, :user, :sent, :received
  
  # XXX undry!
  
  def self.done? event, user
    ec = EventCompensation.where(user_id: user, event_id: event).first
    ec.present? && ec.received && ec.sent
  end
  
  def self.received? event, user
    ec = EventCompensation.where(user_id: user, event_id: event).first
    ec.present? && ec.received
  end
  
  def self.sent? event, user
    ec = EventCompensation.where(user_id: user, event_id: event).first
    ec.present? && ec.sent
  end
end
