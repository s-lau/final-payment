class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    alias_action :read, :update, :destroy, :to => :modify
    
    # all
    can :create, Event
    
    # events owner
    can :modify, Event, owner: user # TODO and event not closed
    can :manage, EventCharge, event: { owner: user } # TODO and event not closed
    can :manage, EventComment, event: { owner: user }
    
    # events participants
    # can :read, Event, ...
    # can :create, EventCharge, ...
    # can [:update, :delete], EventCharge, ... # TODO and event not closed
    # can :create, EventComment, ...
    
    # charges owner
    can :modify, EventCharge, user: user # TODO and event not closed
  end
end
