class Event < ActiveRecord::Base
  include AASM

  belongs_to :owner, foreign_key: "owner", class_name: "User"

  has_many :comments, class_name: "EventComment"
  has_many :charges, class_name: 'EventCharge'

  has_many :event_participations
  has_many :participants, through: :event_participations, source: :user

  monetize :total_costs_cents
  monetize :costs_for_user_cents
  monetize :balance_for_user_cents

  attr_accessible :description, :name, :owner, :closed, :trashed, :trashed_at

  scope :active, where(trashed: false)
  scope :trashed, where(trashed: true)

  

  aasm :column => 'state' do
    state :billing, :initial => true
    state :closed
    state :trashed 

    event :close, :after => :notify_closed do 
      transitions :from => :billing, :to => :closed
    end

    event :trash, :before => ->{previous_state = state} do
      transitions :from => [:closed, :billing], :to => :trashed      
    end
  end

  def acquit user
    self.event_participations.where(user_id: user.id).first.update_attribute(:acquited, true)
  end

  def notify_closed
    notify :close 
  end

  def trash
    self.update_attributes trashed: true, trashed_at: Time.now
  end

  def recover
    self.update_attributes trashed: false, trashed_at: nil
  end

  def total_costs_cents
    charges.sum :price_cents
  end

  def costs_for_user_cents user
    what_user_payed = charges.where("user_id = ?", user).sum :price_cents
    what_everyone_should_pay = (charges.sum :price_cents)/(participants.length+1)
    return Money.new (what_everyone_should_pay - what_user_payed), "EUR"
  end

  def is_owner? user
    self.owner == user
  end

  def is_participant? user
    participants.exists? user or is_owner? user
  end

  def join_token
    Digest::MD5.hexdigest([Chargeback::Application.config.secret_token, created_at.utc.to_i].join)[0..4]
  end

  def is_closable? user
    charges.length > 0 and is_owner? user and not closed
  end
  
  def costs_for_user_cents(user = nil)
    return 0 unless user
    charges.where(user_id: user.id).sum :price_cents
  end
  
  def balance_for_user_cents(user = nil)
    return 0 unless user
    costs_for_user_cents(user) - total_costs_cents / (participants.count + 1) # plus owner 
  end

end
