class EventDecorator < ApplicationDecorator
  decorates :event
  monetize :total_costs, :balance_for_user, :costs_for_user, :abs_balance_for_user
end
