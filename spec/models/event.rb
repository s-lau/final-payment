require 'spec_helper'

describe Event do
  [ :description, :name, :owner, :closed ].each do |field|
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
end
