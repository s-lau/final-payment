class EventCompensation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :event, :user

  def self.done? event, user
    EventCompensation.where(user_id: user, event_id: event).count == 1
  end
end
