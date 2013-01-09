class Event < ActiveRecord::Base
  
  belongs_to :owner, foreign_key: "owner", class_name: "User"

  has_many :comments, class_name: "EventComment"
  has_many :charges, class_name: 'EventCharge'

  has_many :event_participations
  has_many :participants, through: :event_participations, source: :user

  monetize :total_costs_cents
  
  attr_accessible :description, :name, :owner
    
  
  def total_costs_cents
    charges.sum :price_cents
  end
  
  def is_owner? user
    self.owner == user
  end
  
  def is_participant? user
    participants.exists? user or is_owner? user 
  end
end
