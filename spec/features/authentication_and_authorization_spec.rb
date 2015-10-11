require 'spec_helper'
require 'ladle'
require 'rake'
feature 'Visitor can login with correct username and password and role and is otherwise rejected' do

  include TestHelpers

  before(:all) do
    @ldap_server = Ladle::Server.new(:quiet => true,
                                     :domain => 'dc=example,dc=org',
                                     :verbose => true,
                                     :tmpdir => Dir.tmpdir,
                                     :java_bin => ["java", "-Xmx64m"],
                                     :ldif => File.expand_path('../../fixtures/tufts_ldap.ldif', __FILE__)).start
    if ENV["TRAVIS"]
#       Rake::Task["db:seed"].invoke
       load "#{Rails.root}/db/seeds.rb"
    end
  end

  after(:all) do
   @ldap_server.stop
  end
  scenario 'a known user with valid role is rejected with bad password' do
    visit '/'
    page.should have_link "Staff Login"
    click_link 'Staff Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'password'
    click_button 'Log In'
    page.should have_content "Invalid username or password."
  end

  scenario 'a known user with valid role is accepted with correct ldap password' do

    visit '/'
    page.should have_link "Staff Login"
    click_link 'Staff Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'aa729'
    fill_in 'user_password', :with=>'smada'
    click_button 'Log In'
    page.should have_content "Signed in successfully."
  end

#  scenario 'a known user with invalid role is rejected with correct ldap password' do
#    visit '/'
#    page.should have_link "Staff Login"
#    click_link 'Staff Login'
#    page.should have_content "Tufts Username"
#    fill_in 'user_username', :with=>'bb459'
#    fill_in 'user_password', :with=>'niwdlab'
#    click_button 'Log In'
#    page.should have_content "Invalid username or password."
#  end

  scenario 'a known user with invalid role is rejected with incorrect ldap password' do
    visit '/'
    page.should have_link "Staff Login"
    click_link 'Staff Login'
    page.should have_content "Tufts Username"
    fill_in 'user_username', :with=>'bb459'
    fill_in 'user_password', :with=>'niwdlabNOT'
    click_button 'Log In'
    page.should have_content "Invalid username or password."
  end

end
