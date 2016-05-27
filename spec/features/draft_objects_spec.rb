require 'spec_helper'
require 'ldap_helpers'

feature 'Visitor goes directly to draft object in the TDL' do


  include LdapHelpers

  before(:all) do

    start_ldap_server

#    if ENV["TRAVIS"]
#      load "#{Rails.root}/db/seeds.rb"
#    end

  end

  after(:all) do
    stop_ldap_server
  end

  scenario 'An unauthenticated user goes to draft object and is redirected to the login page' do
    visit '/catalog/draft:12423'
    page.should have_content "You need to sign in before continuing."
  end

  scenario 'A Digital Repository Admin navigates to a draft, is challenged for LDAP password, and can retrieve draft object upon logging in' do
    visit '/catalog/draft:12423'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'smada'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
    page.should have_content "A Draft Object"
  end

  scenario 'A non-admin Tufts user navigates to a draft, is challenged for LDAP password, and can NOT retrieve draft object upon logging in' do
    visit '/'
    page.should have_link "Staff Login"
    click_link 'Staff Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'cc414'
    fill_in 'user_password', :with=>'retneprac'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
    visit '/catalog/draft:12423'
    page.should have_content "Draft objects are only available to library and DCA staff."
  end


end
