FactoryGirl.define do
  factory :event do
    description "Example Event"
    association :owner, factory: :confirmed_user
  end
end
