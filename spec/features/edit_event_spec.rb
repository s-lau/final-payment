# encoding: utf-8
require 'spec_helper'

feature '2.А Editieren eines Ereignises' do
  background do
    user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: user
  end

  scenario 'Edit comment' do
    sign_in_with 'user@example.com', '123456'

    visit "events"

    click_link "link_edit_event_#{@event.id}"

    current_path.should eql(edit_event_path(@event))

    within '#owner_email' do
      page.should have_content @event.owner.email
    end

    fill_in 'event_description', with: 'Hello World'
    fill_in 'event_name', with: 'Party'

    click_button 'save_button'

    current_path.should eql(event_path(@event))
    page.should have_content 'Hello World'
    page.should have_content 'Party'



  end

end

