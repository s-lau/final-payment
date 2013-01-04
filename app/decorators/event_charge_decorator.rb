class EventChargeDecorator < ApplicationDecorator
  decorates :event_charge
  monetize :price
end
