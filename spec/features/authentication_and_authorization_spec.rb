require 'spec_helper'
require 'ldap_helpers'

feature 'Visitor can login with correct username and password and role and is otherwise rejected' do

  include LdapHelpers

  before(:all) do

    start_ldap_server

#    if ENV["TRAVIS"]
#       load "#{Rails.root}/db/seeds.rb"
#    end
  end

  after(:all) do
    stop_ldap_server
  end

  scenario 'A user can successfully log out' do
    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'smada'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
    click_link 'Log out aa729'
    page.should have_content "Signed out successfully."
  end
  
  scenario 'A Digital Repository Admin with valid role is rejected with bad password' do
    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'password'
    click_button 'Log In'
    page.should have_content "Invalid username or password."
  end

  scenario 'A Digital Repository Admin with valid role sucessfully logs in with correct ldap password' do

    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'smada'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
  end

  scenario 'A Tufts user who is not a Digital Repository Admin is can login with a valid account' do
    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'bb459'
    fill_in 'user_password', :with=>'niwdlab'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
  end

  scenario 'A Tufts user is assinged the role community_member when logging in' do
    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'dd945'
    fill_in 'user_password', :with=>'noswad'
    click_button 'Log In'
    wait(3.seconds)
    user = User.find_by_user_key('dd945')
    user.has_role?(:community_member).should be_true
  end

  scenario 'A Tufts user who is not a Digital Repository Admin is rejected with correct ldap password' do
    visit '/'
    page.should have_link "Login"
    click_link 'Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'bb459'
    fill_in 'user_password', :with=>'niwdlabNOT'
    click_button 'Log In'
    page.should have_content "Invalid username or password."
  end

end
