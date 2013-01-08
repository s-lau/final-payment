# encoding: utf-8
require 'spec_helper'

feature '13 B: Registration' do
  
  scenario 'Successful Registration' do
    -> {
      sign_up_with 'user@example.com', '123456', 'user'
    }.should change(User, :count).by 1
  end

end
