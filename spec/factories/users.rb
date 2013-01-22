# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :email do |n|
    "example#{n}@example.com"
  end

  sequence :username do |n|
    "user#{n}"
  end

  factory :confirmed_user, class: User do
    email
    password "123"
    username
    confirmed_at 7.weeks.ago
    confirmation_token "123"
    confirmation_sent_at 8.weeks.ago
  end

  factory :unconfirmed_user, class: User do
    email
    password "123"
    username
  end
end
