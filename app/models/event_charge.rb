class EventCharge < ActiveRecord::Base
  
  belongs_to :event, foreign_key: :event_uuid, primary_key: :uuid
  belongs_to :user
  
  attr_accessible :name, :price
  
  monetize :price_cents
  
  validates :name, presence: true
  
  after_initialize do
    self.price_cents = nil if self.price_cents == 0
  end
  
end
