#encoding: utf-8
require 'spec_helper'

feature '15 A: Benutzer tritt "Ereignis" bei' do

  background do
    alice = User.create! email: 'user1@example.com', password: '123456', username: 'Alice'
    bob = User.create! email: 'user2@example.com', password: '123456', username: 'Bob' 
    @event = Event.create! name: 'TEST', owner: alice
  end

  scenario 'Join and leave event' do
    sign_in_with 'user2@example.com', '123456'
    visit event_path(@event)
    -> {
      click_on 'Beitreten'
    }.should change(@event.event_participations, :count).by 1
    
    -> {
      click_on 'Verlassen'
    }.should change(@event.event_participations, :count). by -1
  end


end
