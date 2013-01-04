class Event < ActiveRecord::Base
  self.primary_key = "uuid"
  
  belongs_to :owner, foreign_key: "owner", class_name: "User"
  has_many :charges, class_name: 'EventCharge', foreign_key: :event_uuid
  
  monetize :total_costs_cents
  
  attr_accessible :description, :name, :uuid, :owner
  before_create :generate_uuid
  
  
  def total_costs_cents
    charges.sum :price_cents
  end
  
  # TODO replace with CanCan authorization
  def is_owner? user
    self.owner == user
  end
  
  
  private
  #TODO put uuidtools mixin in lib/
  def generate_uuid
    self.uuid = UUIDTools::UUID.timestamp_create().to_s
  end
end
