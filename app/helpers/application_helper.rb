module ApplicationHelper
  
  def disabled_if(bool)
    bool ? 'disabled' : false
  end
  
end
