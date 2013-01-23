# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_charge do
    name "MyString"
    price_cents 1
    event nil
  end
end
