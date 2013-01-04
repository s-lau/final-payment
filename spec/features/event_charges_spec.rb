# encoding: utf-8
require 'spec_helper'

feature '5 C: Kostenpunkt bzw. Posten zu Ereignis hinzufügen' do
  background do
    # TODO use factory girl...
    user = User.create! email: 'user@example.com', password: '123456'
    @event = Event.create! name: 'TEST', owner: user
  end
  
  scenario 'Create charge' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)
    within '#main #charges' do
      fill_in 'Name', :with => 'Ausgabe'
      fill_in 'Preis', :with => '12,34'
    end
    -> {
      click_button 'Speichern'
    }.should change(@event.charges, :count).by 1
    
    current_path.should eql(event_path(@event))
    
    within '#main #charges .table tr:nth-child(2)' do
      page.should have_content 'Ausgabe'
      page.should have_content '€12,34'
    end
  end

end

feature '6. C: Kostenpunkt bzw. Posten bearbeiten/löschen' do
  background do
    # TODO use factory girl...
    user = User.create! email: 'user@example.com', password: '123456'
    @event = Event.create! name: 'TEST', owner: user
    @event_charge = @event.charges.create! name: 'Cafe', price: '25,00'
  end
  
  scenario 'Edit charge' do
    sign_in_with 'user@example.com', '123456'
    visit event_path(@event)
    
    within '#main #charges .table' do
      click_on 'Bearbeiten'
    end
    
    current_path.should eql(edit_event_charge_path(@event, @event_charge))
    
    within '#main' do
      find_field('Name').value.should eql('Cafe')
      fill_in 'Preis', with: '23,24'
    end
    -> {
      click_button 'Speichern'
      @event_charge.reload
    }.should change(@event_charge, :price_cents).from(2500).to 2324
    
    current_path.should eql(event_path(@event))
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
