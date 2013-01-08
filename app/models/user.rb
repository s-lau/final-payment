class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :description, :username
  # attr_accessible :title, :body

  validates_presence_of :username
  validates_uniqueness_of :username, :email

  has_many :events, foreign_key: "owner"
  has_many :event_participations
  has_many :joined_events, through: :event_participations, source: :event
  has_many :charges, class_name: 'EventCharge'
end
