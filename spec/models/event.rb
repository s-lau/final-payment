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
end
