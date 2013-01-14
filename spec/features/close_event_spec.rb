#encoding: utf-8
require 'spec_helper'

feature '4. C Titel: Abrechnung eines Ereignisses' do
   background do
    # TODO use factory girl...
    user1 = User.create! email: 'user1@example.com', password: '123456', username: 'Foo'
    @user2 = User.create! email: 'xeper000@gmail.com', password: '123456', username: 'Bar'
    @event = Event.create! name: 'TEST', owner: user1
  end

  scenario 'Close event1' do
    sign_in_with 'user1@example.com', '123456'
    visit event_path(@event)
    
      page.should_not have_button('Abrechnen')
    
  end


  scenario 'Close event2' do

    sign_in_with 'user1@example.com', '123456'
    
    @event.charges.create! name: 'Cafe', price: '25,00'
   
    @event.participants << @user2
    
    visit event_path(@event)
    -> {
      click_on 'Abrechnen'
    }.should change(ActionMailer::Base.deliveries,:size).by(1)
    
  end

end
