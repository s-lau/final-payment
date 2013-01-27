class EventCharge < ActiveRecord::Base

  belongs_to :event
  belongs_to :user

  monetize :price_cents
  mount_uploader :bill, BillUploader

  attr_accessible :name, :price, :bill, :remove_bill

  validates :name, presence: true

  after_initialize do
    self.price_cents = nil if self.price_cents == 0
  end

  def self.total
    all.sum(&:price_cents)
  end

end
