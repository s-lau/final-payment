# encoding: utf-8
require 'spec_helper'

feature '13 B: Registration' do

  scenario 'Successful Registration' do
    -> {
      sign_up_with 'user@example.com', '123456', 'user'
    }.should change(ActionMailer::Base.deliveries,:size).by(1)
    User.count.should be 1
    User.first.confirmed?.should be false
    User.first.confirm!
    User.first.confirmed?.should be true
  end

end
