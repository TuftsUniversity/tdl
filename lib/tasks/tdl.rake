Rake::Task[:default].prerequisites.clear

task :default => 'tufts_dca:ci'
