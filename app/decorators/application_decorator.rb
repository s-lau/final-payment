class ApplicationDecorator < Draper::Base
  def self.monetize(*attrs)
    attrs.each do |m|
      define_method m do
        h.humanized_money_with_symbol @model.send(m)
      end
    end
  end
end