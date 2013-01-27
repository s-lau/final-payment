# encoding: utf-8
module Features
  module SessionHelpers
    def sign_up_with(email, password, username)
      visit new_user_registration_path
      within '#main' do
        fill_in 'E-Mail', :with => email
        # fill_in 'Passwort', :with => '123456'
        # raises Ambiguous match, found 2 elements matching field "Passwort"
        find('#user_password').set password
        fill_in 'Username', :with => username
        fill_in 'Passwort bestätigen', :with => password
      end
      
      click_button 'Registrieren'
    end

    def sign_in_with(email, password)
      visit new_user_session_path
      within '#main' do
        fill_in 'E-Mail', :with => email
        fill_in 'Passwort', :with => password
      end
      click_button 'Anmelden'
    end
    def sign_out
      click_link 'Abmelden'
    end
  end
end
