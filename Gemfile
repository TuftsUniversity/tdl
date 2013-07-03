source 'http://rubygems.org'
ruby '2.0.0'
#ruby-gemset=hydra6
gem 'rails', '3.2.13'

gem 'blacklight'
gem 'hydra-head', '~> 6.0.0'
gem 'tuftsification-hydra', :git => 'git@github.com:TuftsUniversity/tuftsification-hydra.git'
gem "active-fedora", "~> 6.3.0"
gem 'om', git: 'https://github.com/projecthydra/om.git', branch: 'fix_serializing_nil'

gem "blacklight_advanced_search"

# We will assume that you're using sqlite3 for testing/demo,
# but in a production setup you probably want to use a real sql database like mysql or postgres
gem 'sqlite3'

# Rails uses asset pipeline.  You will need these gems for used your assets in development.
# However, you won't need them in production because they will be precompiled.
group :assets do
   gem 'sass-rails', '~> 3.2.3'
   gem 'jquery-rails'
end

# You will probably want to use these to run the tests you write for your hyd   ra head
# For testing with rspec
group :development, :test do
   gem 'rspec-rails'
   gem 'jettywrapper'
end

gem "unicode", :platforms => [:mri_18, :mri_19]
gem "devise"
gem "devise-guests", "~> 0.3"
gem "bootstrap-sass"
