class EventDecorator < ApplicationDecorator
  decorates :event
  monetize :total_costs
  monetize :costs_for_user
  
#  def costs_for_user user
 #   costs_for_user_cents user
  #end
end
