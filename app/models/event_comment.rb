class EventComment < ActiveRecord::Base
  attr_accessible :text

  belongs_to :author, foreign_key: "user_id", class_name: "User"
  belongs_to :event
  
  audit :create, :update, :destroy, on: :event, except: [:created_at, :updated_at]

  validates_presence_of :text
end
