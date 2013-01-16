module ApplicationHelper
  
  def disabled_if(bool)
    bool ? 'disabled' : false
  end
  
  def localized_options(collection, scope = '')
    collection.map do |key|
      [I18n.t(key, :scope => scope), key]
    end
  end
  
end
