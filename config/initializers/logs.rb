# http://robaldred.co.uk/2009/01/custom-log-files-for-your-ruby-on-rails-applications/

#collection_facet_error_logfile = File.open("#{Rails.root}/log/collection_facet_error.log")
COLLECTION_ERROR_LOG = ActiveSupport::BufferedLogger.new("#{Rails.root}/log/collection_facet_error.log")
#collection_facet_error_logfile.sync = true
#COLLECTION_ERROR_LOG = CollectionErrorLogger.new(collection_facet_error_logfile)
