class EventParticipation < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  
  audit :create, :update, :destroy, on: :event, except: [:created_at, :updated_at]
end
