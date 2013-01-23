# encoding: utf-8
require 'spec_helper'

feature '5 C: Kostenpunkt bzw. Posten zu Ereignis hinzufügen' do
  background do
    user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: user
  end

  scenario 'Create charge' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)
    within '#main #charges' do
      fill_in 'Name', :with => 'Ausgabe'
      fill_in 'Preis', :with => '18,24'
      attach_file 'Rechnung', 'spec/fixtures/bill.jpg'
      -> {
        click_button 'Speichern'
      }.should change(@event.charges, :count).by 1
    end

    current_path.should eql(event_path(@event))

    within '#main #charges .table tr:nth-child(2)' do
      page.should have_content 'Ausgabe'
      page.should have_content '€18,24'
      page.should have_css 'td a img'
    end
  end

end

feature '6. C: Kostenpunkt bzw. Posten bearbeiten/löschen' do
  background do
    user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
    @event = FactoryGirl.create :event, owner: user
    @event_charge = @event.charges.build name: 'Cafe', price: '25,00'
    @event_charge.bill.store! File.open('spec/fixtures/bill.jpg')
    @event_charge.save!
  end

  scenario 'Edit charge' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)

    within '#main #charges .table tr:nth-child(2)' do
      page.should have_content 'Cafe'
      page.should have_content '€25'
      page.should have_css 'td a img'
    end

    within '#main #charges .table' do
      click_on 'Bearbeiten'
    end

    current_path.should eql(edit_event_charge_path(@event, @event_charge))

    within '#main' do
      find_field('Name').value.should eql('Cafe')
      fill_in 'Preis', with: '23,24'
      check 'Rechnung löschen'
    end

    click_button 'Speichern'

    current_path.should eql(event_path(@event))

    within '#main #charges .table tr:nth-child(2)' do
      page.should have_content '€23,24'
      page.should_not have_css 'td a img'
    end
  end

  scenario 'Delete charge' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)

    within '#main #charges .table' do
      -> {
        click_on 'Löschen'
      }.should change(@event.charges, :count).by -1
    end

    current_path.should eql(event_path(@event))
  end
end
