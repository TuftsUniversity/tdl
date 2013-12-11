namespace :solrizer do
  
  namespace :fedora  do
    desc 'Index a fedora object of the given pid.'
    task :solrize => :environment do 
      if ENV['PID']
        puts "indexing #{ENV['PID'].inspect}"
        ActiveFedora::Base.find(ENV['PID'], cast: true).update_index
        puts "Finished shelving #{ENV['PID']}"
      else
        puts "You must provide a pid using the format 'solrizer::solrize_object PID=sample:pid'."
      end
    end
  
    desc 'Index all objects in the repository.'
    task :solrize_objects => :environment do
      if ENV['INDEX_LIST']
        @@index_list = ENV['INDEX_LIST']
      end
    
      puts "Re-indexing Fedora Repository."
      puts "Fedora Solr URL: #{ActiveFedora.solr_config[:url]}"
CSV.foreach(ENV['INDEX_LIST']) do |row|
          pid = row[0]
        ActiveFedora::Base.find(pid,cast: true).update_index
      end 
      puts "Solrizer task complete."
    end  
  end
end
