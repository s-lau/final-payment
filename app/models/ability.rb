class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    alias_action :read, :update, :destroy, :to => :modify
    
    # all
    can :create, Event
    can :join, Event
    can :leave, Event

    # events owner
    can :modify, Event, owner: user # TODO and event not closed
    can :manage, EventCharge, event: { owner: user } # TODO and event not closed
    can :manage, EventComment, event: { owner: user }
    
    # events participants
    can :read, Event, event_participations: { user_id: user.id }
    can :create, EventCharge, event: { event_participations: { user_id: user.id } }
    can :modify, EventCharge, user: user # TODO and event not closed
    can :create, EventComment, event: { event_participations: { user_id: user.id } }
  end
end
