require 'csv'
require 'active_fedora'
require 'fileutils'
require 'open-uri'
require 'uri'



namespace :tufts_data do

  @cache_logger = Logger.new('cache.log')

  task :clear_tdl_cache, [:arg1] => :environment do |t, args|


    if args[:arg1].nil?
      puts 'YOU MUST SPECIFY FULL PATH TO FILE OF PIDS, ABORTING!'
      next
    end

    dry_run = false
    base_dir = '/tdr/ase_data/tisch01/tdl_cache/'

    CSV.foreach(args[:arg1], encoding: 'ISO8859-1') do |row|
      pid = row[0]
      begin
        path = base_dir + '**/views%2F' + pid.gsub(':','%3A') + '*'
        files = Dir[path]
        files.each do |file| 
           FileUtils.rm(file)
           puts "deleted #{file}" 
        end 
      rescue => exception
        @cache_logger.error "ERROR There was an error collecting data for: #{pid}"
        puts exception
        puts exception.backtrace
        next
      end
    end
  end
end
