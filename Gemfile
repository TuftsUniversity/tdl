source 'http://rubygems.org'
ruby '2.0.0'
gem 'rails', '3.2.16'

gem 'hydra', '6.1.0'

gem 'tuftsification-hydra', :git => 'https://github.com/TuftsUniversity/tuftsification-hydra', :tag => '1.2.9'
#gem 'tuftsification-hydra', :path => '/Users/mkorcy01/Documents/workspace/tuftsification-hydra'
#gem 'tuftsification-hydra', :path => '../tuftsification-hydra'

#gem 'solrizer', :path => '/home/hydradm/tdl_solrizer'
#gem 'solrizer', :git => 'https://github.com/TuftsUniversity/tdl_solrizer'
#gem 'solrizer', :path => '/home/hydradm/tdl_solrizer'
#gem 'solrizer'
gem 'solrizer', :git => 'https://github.com/TuftsUniversity/tdl_solrizer.git'
# Pointing at our fork of blacklight_advanced_search until 
# https://github.com/projectblacklight/blacklight_advanced_search/pull/10 is merged

gem "blacklight_advanced_search", :git => 'https://github.com/whumph/blacklight_advanced_search'
gem 'chronic' # for lib/tufts/model_methods.rb
gem 'titleize' # for lib/tufts/model_methods.rb
gem 'settingslogic' # for settings

# We will assume that you're using sqlite3 for testing/demo,
# but in a production setup you probably want to use a real sql database like mysql or postgres
gem 'sqlite3'

# Rails uses asset pipeline.  You will need these gems for used your assets in development.
# However, you won't need them in production because they will be precompiled.
group :assets do
   gem 'therubyracer'
   gem 'sass-rails', '~> 3.2.3'
   gem 'jquery-rails'
   gem 'uglifier'
end

# You will probably want to use these to run the tests you write for your hyd   ra head
# For testing with rspec
group :development, :test do
   gem 'rspec-rails'
   gem 'jettywrapper'
   gem 'pry'
   gem 'capybara'
   gem 'simplecov'
   gem 'simplecov-rcov'
   gem 'launchy'
   gem 'ci_reporter'
   gem 'ladle'
   gem 'database_cleaner'
   gem 'poltergeist'
   gem 'selenium-webdriver'
   gem 'rubocop', require: false
   gem 'rubocop-rspec', require: false
   gem "byebug"
end

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise"
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"
gem 'mysql2', "~> 0.3.17"
gem 'activerecord-mysql-adapter'
gem 'google-analytics-rails'

gem 'hydra-role-management', '0.1.0'
gem 'devise_ldap_authenticatable', '0.8.1'
gem "rails_admin"
gem "is_it_working"
