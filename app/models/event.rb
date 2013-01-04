class Event < ActiveRecord::Base
  attr_accessible :description, :name, :uuid, :owner
  before_create :generate_uuid
  self.primary_key = "uuid"
  belongs_to :owner, foreign_key: "owner", class_name: "User"
  has_many :comments, foreign_key: "event_uuid", class_name: "EventComment"

  private
  #TODO put uuidtools mixin in lib/
  def generate_uuid
    self.uuid = UUIDTools::UUID.timestamp_create().to_s
  end
end
