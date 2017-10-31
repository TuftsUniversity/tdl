SitemapGenerator::Sitemap.default_host = 'https://dl.tufts.edu'

SitemapGenerator::Sitemap.create do
  # We set a boolean value in our environment files to prevent generation in staging or development
  break unless Rails.application.config.sitemap[:generate]

  # Add static pages
  # This is quite primitive - could perhaps be improved by querying the Rails routes in the about namespace
  ['about'].each do |page|
    add "/#{page}", :changefreq => 'yearly', :priority => 0.9
  end

  # Add single record pages
  cursorMark = '*'
  loop do
    response = Blacklight.solr.get('/solr/development/select', :params => { # you may need to change the request handler
      'q'          => 'displays_ssi:dl', # all docs
      'fl'         => 'id', # we only need the ids
      'fq'         => '-id:draft*', # optional filter query
      'cursorMark' => cursorMark, # we need to use the cursor mark to handle paging
      'rows'       => ENV['BATCH_SIZE'] || 1000,
      'sort'       => 'id asc'
    })
    
    response['response']['docs'].each do |doc|
      add "/catalog/#{doc['id']}", :changefreq => 'yearly', :priority => 0.9
    end

    break if response['nextCursorMark'] == cursorMark # this means the result set is finished

    cursorMark = response['nextCursorMark']
  end
end
