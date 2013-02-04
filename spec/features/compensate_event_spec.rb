
#encoding: utf-8
require 'spec_helper'

feature '11 C Betrag als eingegangen markieren' do
   background do
    user1 = FactoryGirl.create :confirmed_user, email: "test@example.com", password: "123"
    FactoryGirl.create_list :confirmed_user, 3
    @user2 = User.find(2)
    @user3 = User.find(3)
    @event = FactoryGirl.create :event, owner: user1
  end

  scenario 'Mark as compensated' do

    sign_in_with 'test@example.com', '123'

    @event.charges.create! name: 'Cafe', price: '25,00'

    @event.participants << @user2
    @event.participants << @user3
    @event.update_attribute :closed, true

    visit event_path(@event)
    @event.status.should eq :in_compensation
    click_link 'markascompensated_button'
    @event.reload
    @event.status.should eq :compensated
  end


end
