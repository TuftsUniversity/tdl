source 'http://rubygems.org'
ruby '2.0.0'
#ruby-gemset=hydra6
gem 'rails', '3.2.16'

gem 'hydra', '6.1.0', require: 'hydra6'
gem 'tuftsification-hydra', :git => 'https://github.com/TuftsUniversity/tuftsification-hydra'
#gem 'solrizer', :path => '/home/hydradm/tdl_solrizer'
gem 'solrizer', :git => 'https://github.com/TuftsUniversity/tdl_solrizer'
#gem  'tuftsification-hydra', :path => '/home/hydradm/tuftsification-hydra'
#Pointing at our fork of blacklight_advanced_search until https://github.com/projectblacklight/blacklight_advanced_search/pull/10 is merged
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
end

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise"
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"
gem 'mysql2'
gem 'activerecord-mysql-adapter'
gem 'google-analytics-rails'
