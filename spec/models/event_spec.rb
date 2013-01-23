require 'spec_helper'

describe Event do
  [ :description, :name, :owner, :closed, :trashed, :trashed_at].each do |field|
    it { should respond_to field }
  end

  context 'CRUD' do
    before :each do
      Event.create
    end
    it '#create' do
      Event.count.should eq 1
    end
    it '#update_attributes' do
      Event.first.update_attributes description: "Hello World"
      Event.first.description.should eq "Hello World"
    end
    it '#delete' do
      Event.count.should eq 1
      Event.first.delete
      Event.count.should eq 0
    end
  end

  context 'trashing' do
    before :each do
      FactoryGirl.create_list :event, 5
      @event_to_trash = Event.all.second
    end
    it 'does trash event' do
      Event.count.should eq 5
      Event.active.count.should eq 5
      Event.trashed.count.should eq 0
      @event_to_trash.trash
      Event.count.should eq 5
      Event.active.count.should eq 4
      Event.trashed.count.should eq 1
    end

    it 'recovers trashed events' do
      @event_to_trash.trash
      Event.trashed.count.should eq 1
      @event_to_trash.recover
      Event.trashed.count.should eq 0
    end
  end
  
  context 'prices' do
    #include MoneyRails::TestHelpers
    before :each do
      @event = FactoryGirl.create :event
      @owner = @event.owner
      @u1 = FactoryGirl.create :confirmed_user
      @u2 = FactoryGirl.create :confirmed_user
      @event.participants << @u1
      @event.participants << @u2
      FactoryGirl.create :event_charge, event: @event, price_cents: 1000, user: @owner
      FactoryGirl.create :event_charge, event: @event, price_cents: 100, user: @owner
      FactoryGirl.create :event_charge, event: @event, price_cents: 100, user: @u1
    end
    it 'should sum all charges' do
      #monetize(:total_costs_cents).as(:total_price).with_currency(:eur).should be_true
      @event.total_costs_cents.should eql 1200
    end
    it 'should return users contribution (accounts total balance)' do
      #monetize(:costs_for_user_cents).as(:costs_for_user).with_currency(:eur).should be_true
      @event.costs_for_user_cents(@owner).should eql 1100
      @event.costs_for_user_cents(@u1).should eql 100
      @event.costs_for_user_cents(@u2).should eql 0
    end
    it 'should balance contributions (accounts relative balance)' do
      #monetize(:balance_for_user_cents).as(:balance_for_user).with_currency(:eur).should be_true
      @event.balance_for_user_cents(@owner).should eql 700
      @event.balance_for_user_cents(@u1).should eql -300
      @event.balance_for_user_cents(@u2).should eql -400
    end
  end
end
