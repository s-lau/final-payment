FactoryGirl.define do
  factory :event do
    description "Example Event"
    name "Party"
    association :owner, factory: :confirmed_user
  end
end
