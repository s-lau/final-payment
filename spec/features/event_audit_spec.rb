#encoding: utf-8
require 'spec_helper'

feature '20 D Titel: Ereignisverlauf ansehen' do
   background do
    @user1 = FactoryGirl.create :confirmed_user, email: 'user1@example.com', password: '123456'
    @user2= FactoryGirl.create :confirmed_user, email: 'user2@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: @user1
  end

  scenario 'event changes' do
    sign_in_with 'user1@example.com', '123456'
    
    visit event_path(@event)
    
    page.should_not have_css '#changes'
    -> {
      @event.update_attribute :description, 'QWERTZ'
    }.should change(Audit, :count).by(1)
    
    visit event_path(@event)
    within '#changes' do
      page.all('li').should have(1).elements
      page.should have_content('Ereignis geändert (Beschreibung)')
    end
  end
  
  scenario 'event charge' do
    sign_in_with 'user1@example.com', '123456'
    
    -> {
      ec = FactoryGirl.create :event_charge, event: @event, name: 'TEE', user: @user1
      ec.update_attribute :name, 'Schwarztee'
    }.should change(Audit, :count).by(2)
    
    visit event_path(@event)
    within '#changes' do
      page.all('li').should have(2).elements
      page.should have_content('Kostenpunkt "TEE" erstellt')
      page.should have_content @user1.username
      page.should have_content('Kostenpunkt "Schwarztee" geändert (Name)')
    end
  end
  
  scenario 'participants' do
    sign_in_with 'user2@example.com', '123456'
    
    -> {
      @event.participants << @user2
    }.should change(Audit, :count).by 1
    
    visit event_path(@event)
    within '#changes' do
      page.all('li').should have(1).element
      page.should have_content('beigetreten')
      page.should have_content @user2.username
    end
    
    -> {
      @event.event_participations.destroy_all
    }.should change(Audit, :count).by 1
    
    sign_out
    sign_in_with 'user1@example.com', '123456'
    visit event_path(@event)
    within '#changes' do
      page.all('li').should have(2).elements
      page.should have_content('verlassen')
    end
  end

end
