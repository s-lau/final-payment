#encoding: utf-8
require 'spec_helper'

feature '12 D: Oberflächensprache ändern' do

  background do
    @user = FactoryGirl.create :confirmed_user, email: 'user@example.com', password: '123456'
  end

  scenario 'Default locale active and selected' do
    I18n.default_locale.should eql(:de)

    visit new_user_session_path

    page.should have_content 'Anmelden'
    page.should have_css 'select#locale option[selected][value=de]'
  end

  scenario 'Change locale' do
    visit new_user_session_path
    page.should have_content 'Anmelden'

    visit new_user_session_path locale: 'en'
    page.should have_content 'Sign in'
    page.should have_css 'select#locale option[selected][value=en]'

    visit new_user_session_path
    page.should have_content 'Sign in'
  end

  scenario 'Save locale to user' do
    sign_in_with 'user@example.com', '123456'

    page.should have_content 'Ereignis'

    @user.reload

    -> {
      visit events_path locale: 'en'
      page.should have_content 'Event'
      @user.reload
    }.should change(@user, :locale).from('de').to 'en'

    -> {
      visit events_path locale: 'de'
      page.should have_content 'Ereignis'
      @user.reload
    }.should change(@user, :locale).from('en').to 'de'
  end


end
