# encoding: utf-8
require 'spec_helper'

feature '14 B: Login' do
  background do
    User.create! :email => 'user@example.com', :password => '123456'
  end
  
  scenario 'Successful Login' do
    sign_in_with 'user@example.com', '123456'
    
    current_path.should eql(events_path)
  end

end
