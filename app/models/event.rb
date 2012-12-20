class Event < ActiveRecord::Base
  attr_accessible :description, :name, :uuid
  before_create :generate_uuid
  self.primary_key = "uuid"

  private
  #TODO put uuidtools mixin in lib/
  def generate_uuid
    require 'pry'; binding.pry
    self.uuid = UUIDTools::UUID.timestamp_create().to_s
  end
end
