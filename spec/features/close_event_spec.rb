#encoding: utf-8
require 'spec_helper'

feature '4. C Titel: Abrechnung eines Ereignisses' do
   background do
    # TODO use factory girl...
    user1 = User.create! email: 'user1@example.com', password: '123456', username: 'Foo'
    @user2 = User.create! email: 'user2@example.com', password: '123456', username: 'Bar'
    @user3 = User.create! email: 'user3@example.com', password: '123456', username: 'Barbar'
    @event = Event.create! name: 'TEST', owner: user1
  end

  scenario 'Close event and notify participants' do

    sign_in_with 'user1@example.com', '123456'
    
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
