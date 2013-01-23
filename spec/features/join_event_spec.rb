#encoding: utf-8
require 'spec_helper'

feature '15 A: Benutzer tritt "Ereignis" bei' do

  background do
    alice = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    bob = FactoryGirl.create :confirmed_user, email: 'user2@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: bob
  end

  scenario 'Join and leave event' do
    sign_in_with 'user@example.com', '123456'

    # wrong token
    -> {
      visit join_event_path(@event, token: 'foooo')
    }.should_not change(@event.event_participations, :count)

    # right token
    -> {
      visit join_event_path(@event, token: @event.join_token)
    }.should change(@event.event_participations, :count).by 1

    -> {
      click_on 'Verlassen'
    }.should change(@event.event_participations, :count). by -1
  end


end
