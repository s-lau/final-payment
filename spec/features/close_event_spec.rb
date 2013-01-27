#encoding: utf-8
require 'spec_helper'

feature '4. C Titel: Abrechnung eines Ereignisses' do
   background do
    user1 = FactoryGirl.create :confirmed_user, email: "test@example.com", password: "123"
    FactoryGirl.create_list :confirmed_user, 3
    @user2 = User.find(2)
    @user3 = User.find(3)
    @event = FactoryGirl.create :event, owner: user1
  end

  scenario 'Close event and notify participants' do

    sign_in_with 'test@example.com', '123'

    @event.charges.create! name: 'Cafe', price: '25,00'

    @event.participants << @user2
    @event.participants << @user3

    visit event_path(@event)
    -> {
      click_on 'Abrechnen'
    }.should change(ActionMailer::Base.deliveries,:size).by(1)

    email = ActionMailer::Base.deliveries.last
    assert_not_nil email
    assert_equal [@user2.email, @user3.email], email.to

  end


end
