class EventComment < ActiveRecord::Base
  attr_accessible :text
  belongs_to :author, foreign_key: "user_id", class_name: "User"
  belongs_to :event, foreign_key: "event_uuid"

  validates_presence_of :text
end
