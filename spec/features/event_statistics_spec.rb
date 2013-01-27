# encoding: utf-8
require 'spec_helper'

feature '19 D Titel: Gesamtstatistik' do
  background do
    user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: user
    charge = FactoryGirl.create :event_charge, event: @event, price_cents: 4000
  end

  scenario 'Create charge' do
    sign_in_with 'user@example.com', '123456'
    visit 'events'

    within '#statistics' do
      page.should have_content '1 Ereignisse'
      page.should have_content '1 Posten'
      page.should have_content '40€!'
    end
  end

end
