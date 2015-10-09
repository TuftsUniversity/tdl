#require File.expand_path(File.dirname(__FILE__) + '/hydra_jetty.rb')
require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
require 'ci/reporter/rake/cucumber'  # use this if you're using Cucumber


#if defined?(Rails) && (Rails.env == 'development')
#  Rails.logger = Logger.new(STDOUT)
#end


#ActiveFedora.init(:fedora_config_path => "#{Rails.root}/config/fedora.yml")

namespace :tufts_dca do

  desc "Execute Continuous Integration build (docs, tests with coverage)"
  task :ci => :environment do
    #Rake::Task["hyhead:doc"].invoke
    #Rake::Task["jetty:config"].invoke
    #Rake::Task["db:drop"].invoke
    #Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Teask["db:seed"].invoke
    require 'jettywrapper'
    Jettywrapper.unzip
    Rake::Task["jetty:config"].invoke
    jetty_params = Jettywrapper.load_config #.merge({:jetty_home => File.expand_path(File.join(Rails.root, 'jetty'))})

    error = nil
    error = Jettywrapper.wrap(jetty_params) do
      sleep(90)
      Rake::Task["tufts:fixtures:refresh"].invoke
      Rake::Task["jetty:config"].invoke
#      Rake::Task['ci:setup:rspec'].invoke
      Rake::Task['spec'].invoke
    end
    raise "test failures: #{error}" if error
  end

end
