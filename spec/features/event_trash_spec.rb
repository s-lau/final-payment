# encoding: utf-8
require 'spec_helper'

feature '3. A Titel: Entfernen eines Ereignis' do
  background do
    # TODO use factory girl...
    user = User.create! email: 'user@example.com', password: '123456', username: 'Foo'
    @event = Event.create! name: 'TEST', owner: user
  end

  scenario 'trash event' do
    sign_in_with 'user@example.com', '123456'
    visit 'events'

    Event.count.should eq 1
    Event.trashed.count.should eq 0
    within "#row_event_#{@event.id}" do
        click_link 'Wegwerfen'
    end
    Event.trashed.count.should eq 1

  end

end

