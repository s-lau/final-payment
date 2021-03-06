# encoding: utf-8
require 'spec_helper'

feature '16 A Titel: Benutzer kommentiert ein Ereignis' do
  background do
    user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: user
  end

  scenario 'Create comment' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)
    within '#main #comments' do
      fill_in 'event_comment_text', :with => 'Hello World'
      -> {
        click_button 'Speichern'
      }.should change(@event.comments, :count).by 1
    end

    current_path.should eql(event_path(@event))

    within '#main .comments' do
      page.should have_content 'Hello World'
    end
  end

end

