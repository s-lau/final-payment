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
    can :read,   Event, owner: user, trashed: false
    can :modify, Event, owner: user, closed: false
    can :close, Event, owner: user, charges?: true, closed: false
    can :compensate, Event, owner: user, closed: true, trashed: false, compensated: false
    can :trash, Event, owner: user, closed: true, compensated: true, trashed: false

    can :manage, EventCharge, event: { owner: user, closed: false }
    can :manage, EventComment, event: { owner: user }

    # events participants
    can :read, Event, event_participations: { user_id: user.id }
    can :create, EventCharge, event: { event_participations: { user_id: user.id }, closed: false }
    can :modify, EventCharge, user: user, event: { closed: false }
    can :create, EventComment, event: { event_participations: { user_id: user.id } }
  end
end
