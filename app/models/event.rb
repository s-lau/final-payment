class Event < ActiveRecord::Base

  belongs_to :owner, foreign_key: "owner", class_name: "User"

  has_many :comments, class_name: "EventComment"
  has_many :charges, class_name: 'EventCharge'

  has_many :event_participations
  has_many :participants, through: :event_participations, source: :user

  monetize :total_costs_cents
  monetize :costs_for_user_cents
  monetize :balance_for_user_cents
  
  attr_accessible :description, :name, :owner, :closed
  attr_protected :trashed, :trashed_at, :compensated, :compensated_at

  audit :update, except: [:created_at, :updated_at]

  scope :active, where(trashed: false)
  scope :trashed, where(trashed: true)
  
  def owned_audits
    Audit.where(owner_type: 'Event', owner_id: id).reorder 'created_at DESC'
  end

  def trash
    self.trashed = true
    self.trashed_at = Time.now
    self.save
  end

  def charges?
    charges.count > 0
  end

  def status
    if self.trashed? then return :trashed end
    if self.closed? then
      if self.compensated? then return :compensated
      else return :in_compensation
      end
    end
    :open
  end

  def recover
    self.trashed = false
    self.trashed_at = nil
    self.save
  end

  def total_costs_cents
    charges.sum :price_cents
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
