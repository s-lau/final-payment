class EventDecorator < ApplicationDecorator
  decorates :event
  monetize :total_costs
end
