module Tufts
  module DarkArchiveMethods

    def is_dark_archive
      return Rails.application.config.dark_archive
    end

    def application_name
      (is_dark_archive ? 'TDL Dark Archive' : 'Tufts Digital Library')
    end 

    def application_logo
      (is_dark_archive ? '/assets/img/tdldarkarchivelogosmall.png' : '/assets/img/tuftsdigitallibrarylogosmall.png')
    end 

    # For files that have dark archive versions, e.g. welcome_dark.html.erb and collections_dark.html.erb
    def dark_suffix
      (is_dark_archive ? '_dark' : '')
    end 

    # For styles that are modified for dark archive, e.g. .blueline and .blue_footer
    def dark_class
      (is_dark_archive ? 'dark' : '')
    end 

  end
end
