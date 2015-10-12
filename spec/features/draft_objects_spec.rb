require 'spec_helper'
require 'ldap_helpers'

feature 'Visitor goes directly to draft object in the TDL' do


  include LdapHelpers

  before(:all) do

    start_ldap_server

    if ENV["TRAVIS"]
      load "#{Rails.root}/db/seeds.rb"
    end

  end

  after(:all) do
    stop_ldap_server
  end

  scenario 'unauthenticated user goes to draft object' do
    visit '/catalog/draft:12423'
    page.should have_content "Draft objects are only available to library and DCA staff."
  end

  scenario 'user logs in to see draft content with role digital_repository_admin' do
#    visit '/'
#    page.should have_link "Staff Login"
#    click_link 'Staff Login'
#    page.should have_content "Tufts Username"
#    fill_in 'user_username', :with=>'aa729'
#    fill_in 'user_password', :with=>'smada'
#    click_button 'Log In'
#    page.should have_content "Signed in successfully."
#    visit '/catalog/draft:12423'
#    page.should have_content "Official letters to the honourable American Congress"
     pending('Visiting draft content')
  end

  scenario 'known user without correct role logs in to see draft object' do
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
