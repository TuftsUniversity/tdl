# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController  

  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Tufts::Catalog

  #before filters..
  before_filter :instantiate_controller_and_action_names
  before_filter :load_fedora_document, :only=>[:show, :edit, :teireader, :eadoverview, :eadinternal, :transcriptonly]
  before_filter :enforce_show_permissions, :only=>:show
  # These before_filters apply the hydra access controls

  # This changes the begin year and end year params of an advanced search into a proper range parameter for solr
  # This filters out embargo'd objects
  #This makes tdl aware of DCA-Admin displays tag
  CatalogController.solr_search_params_logic += [:add_advanced_search_range_param, :exclude_embargo_objects, :add_dca_admin_displays_awareness,:exclude_drafts]

  # Controller "before" filter for enforcing access controls on show actions
  # @param [Hash] opts (optional, not currently used)
  def enforce_show_permissions(opts={})
    unless @document_fedora.datastreams["DCA-ADMIN"].displays.include? "dark"
      flash[:retrieval] = "This item is not available for viewing in the TDL."
      redirect_to(:action=>'index', :q=>nil, :f=>nil) and return false
    end
    if @document_fedora.datastreams["DCA-ADMIN"].under_embargo?
      # check for depositor raise "#{@document["depositor_t"].first} --- #{user_key}"
      ### Assuming we're using devise and have only one authentication key
      #unless current_user && user_key == @permissions_solr_document["depositor_t"].first
      flash[:retrieval] = "This item is under embargo.  You do not have sufficient access privileges to read this document."
      redirect_to(:action=>'index', :q=>nil, :f=>nil) and return false
    end
    id = params[:id]
    unless id.nil?
      if id[/^draft/]

        if current_user.nil?
          authenticate_user!
        end

        if !current_user.nil? and !current_user.has_role? :digital_repository_admin
          flash[:alert] = "Draft objects are only available to library and DCA staff."
          redirect_to(:action=>'index', :q=>nil, :f=>nil) and return false
        end
      end
    end
  end

  # This filters out objects that you want to exclude from search results.  By default it only excludes FileAssets
  # @param solr_parameters the current solr parameters
  # @param user_parameters the current user-subitted parameters
  def exclude_embargo_objects(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "-embargo_dtsim:[NOW TO *]"
  end

  def add_dca_admin_displays_awareness(solr_parameters, user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "(-displays_tesim:[* TO *] AND *:*) OR displays_tesim:dark"
  end

  def exclude_drafts(solr_parameters,user_parameters)
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "-id:draft*"
  end
  # Use params[:id] to load an object from Fedora.  Inspects the object for known models and mixes in any of those models' behaviors.
  # Sets @document_fedora with the loaded object
  # Sets @file_assets with file objects that are children of the loaded object
  def load_fedora_document
    @document_fedora = ActiveFedora::Base.find(params[:id], :cast=>true)
    unless @document_fedora.class.include?(Hydra::ModelMethods)
      @document_fedora.class.send :include, Hydra::ModelMethods
    end

    #@file_assets = @document_fedora.parts(:response_format=>:solr)
  end

  def search
    delete_or_assign_search_session_params

          extra_head_content << view_context.auto_discovery_link_tag(:rss, url_for(params.merge(:format => 'rss')), :title => "RSS for results")
          extra_head_content << view_context.auto_discovery_link_tag(:atom, url_for(params.merge(:format => 'atom')), :title => "Atom for results")

          (@response, @document_list) = get_search_results
          @filters = params[:f] || []
          search_session[:total] = @response.total unless @response.nil?

          respond_to do |format|
            format.html { save_current_search_params }
            format.rss  { render :layout => false }
            format.atom { render :layout => false }
          end
  end

  def eadinternal
    @item_id = params[:item_id]
  end

  def add_advanced_search_range_param(solr_params, req_params)
    year_start = req_params[:year_start]
    year_end = req_params[:year_end]
    year_start_requested = !(year_start.nil? || year_start.empty?)
    year_end_requested = !(year_end.nil? || year_end.empty?)

    if (year_start_requested || year_end_requested)
      # add the properly formatted date range to the parameters that will be passed to solr for the search
      year_range = "pub_date_isi:[" + (year_start_requested ? year_start : "*") + " TO " + (year_end_requested ? year_end : "*") + "]"
      solr_params[:fq] ||= []
      solr_params[:fq] << year_range

      # and remove year_start and year_end so that they will NOT be used in the search;  they will have to be added
      # back after the search so that their nav-pills will appear on the results page (see
      # config/initializers/blacklight_advanced_search_override.rb and app/views/catalog/_constraints.html.erb).
      req_params[:year_start] = ""
      req_params[:year_end] = ""
    end
  end

  #### TDL is not currently enforcing permissions #####
  #before_filter :enforce_show_permissions, :only=>:show
  #### /TDL is not currently enforcing permissions #####

  # This applies appropriate access controls to all solr queries
#  CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]


  configure_blacklight do |config|
    config.default_solr_params = { 
       :qt => 'search',
      :rows => 25
    }

    # solr field configuration for search results/index views
    config.index.show_link = 'title_tesim'
    config.index.record_tsim_type = 'has_model_ssim'

    # solr field configuration for document/show views
    config.show.html_title = 'title_tesim'
    config.show.heading = 'title_tesim'
    config.show.display_type = 'has_model_ssim'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _tsimed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    config.add_facet_field solr_name('object_type', :facetable), :label => 'Format', :limit => 9
    config.add_facet_field solr_name('names', :facetable), :label => 'Names', :limit => 7
    config.add_facet_field solr_name('year', :facetable), :label => 'Year', :limit => 7
    config.add_facet_field solr_name('subject', :facetable), :label => 'Subject', :limit => 7
    config.add_facet_field solr_name('collection', :facetable), :label => 'Collection', :limit => 7

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    config.add_index_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:' 
    config.add_index_field solr_name('title_vern', :stored_searchable, type: :string), :label => 'Title:' 
    config.add_index_field solr_name('author', :stored_searchable, type: :string), :label => 'Author:' 
    config.add_index_field solr_name('author_vern', :stored_searchable, type: :string), :label => 'Author:' 
    config.add_index_field solr_name('format', :symbol), :label => 'Format:' 
    config.add_index_field solr_name('language', :stored_searchable, type: :string), :label => 'Language:'
    config.add_index_field solr_name('published', :stored_searchable, type: :string), :label => 'Published:'
    config.add_index_field solr_name('published_vern', :stored_searchable, type: :string), :label => 'Published:'
    config.add_index_field solr_name('lc_callnum', :stored_searchable, type: :string), :label => 'Call number:'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    config.add_show_field solr_name('title', :stored_searchable, type: :string), :label => 'Title:' 
    config.add_show_field solr_name('title_vern', :stored_searchable, type: :string), :label => 'Title:' 
    config.add_show_field solr_name('subtitle', :stored_searchable, type: :string), :label => 'Subtitle:' 
    config.add_show_field solr_name('subtitle_vern', :stored_searchable, type: :string), :label => 'Subtitle:' 
    config.add_show_field solr_name('author', :stored_searchable, type: :string), :label => 'Author:' 
    config.add_show_field solr_name('author_vern', :stored_searchable, type: :string), :label => 'Author:' 
    config.add_show_field solr_name('format', :symbol), :label => 'Format:' 
    config.add_show_field solr_name('url_fulltext_tsim', :stored_searchable, type: :string), :label => 'URL:'
    config.add_show_field solr_name('url_suppl_tsim', :stored_searchable, type: :string), :label => 'More Information:'
    config.add_show_field solr_name('language', :stored_searchable, type: :string), :label => 'Language:'
    config.add_show_field solr_name('published', :stored_searchable, type: :string), :label => 'Published:'
    config.add_show_field solr_name('published_vern', :stored_searchable, type: :string), :label => 'Published:'
    config.add_show_field solr_name('lc_callnum', :stored_searchable, type: :string), :label => 'Call number:'
    config.add_show_field solr_name('isbn', :stored_searchable, type: :string), :label => 'ISBN:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    config.add_search_field 'all_fields', :label => 'Keyword'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params. 
      # field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = { 
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end
    
    config.add_search_field('author') do |field|
      #field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      field.label = 'Creator/Author'
      field.solr_local_parameters = { 
        :qf => '$author_qf',
        :pf => '$author_pf'
      }
    end

    config.add_search_field('subject') do |field|
      field.include_in_advanced_search = false
      field.solr_local_parameters = {
            :qf => "$subject_qf",
            :pf => "$subject_pf"
        }
    end

    config.add_search_field('collection') do |field|
      field.include_in_simple_select = false
      #field.solr_parameters = { :'spellcheck.dictionary' => 'collection' }
      field.solr_local_parameters = {
        :qf => '$collection_qf',
        :pf => '$collection_pf'
      }
    end

    config.add_search_field('description') do |field|
      field.include_in_simple_select = false
      field.solr_local_parameters = {
            :pf => "$description_pf",
            :qf => "$description_qf"
        }
    end

    config.add_search_field('organization') do |field|
      field.include_in_simple_select = false
      field.label = 'Organizations'
      field.solr_local_parameters = {
          :pf => "$organization_pf",
          :qf => "$organization_qf"
      }
    end

    config.add_search_field('people') do |field|
      field.include_in_simple_select = false
      field.solr_local_parameters = {
            :pf => "$person_pf",
            :qf => "$person_qf"
        }
    end

    config.add_search_field('place') do |field|
      field.include_in_simple_select = false
      field.label = 'Places'
        field.solr_local_parameters = {
            :pf => "$place_pf",
            :qf => "$place_qf"
        }
    end

    config.add_search_field('topic') do |field|
      field.include_in_simple_select = false
      field.label = 'Topics'
        field.solr_local_parameters = {
            :pf => "$topic_pf",
            :qf => "$topic_qf"
        }
    end

  config.add_search_field('year_start') do |field|
    field.include_in_simple_select = false
    field.label = 'Year Start'
    field.solr_local_parameters = {
      :pf => "$year_start_pf",
      :qf => "$year_start_qf"
    }
  end

  config.add_search_field('year_end') do |field|
    field.include_in_simple_select = false
    field.label = 'Year End'
    field.solr_local_parameters = {
      :pf => "$year_end_pf",
      :qf => "$year_end_qf"
    }
  end


    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_isi desc, title_si asc', :label => 'relevance'
    config.add_sort_field 'pub_date_isi desc, title_si asc', :label => 'year descending'
    config.add_sort_field 'author_si asc, title_si asc', :label => 'author ascending'
    config.add_sort_field 'title_si asc, pub_date_isi asc', :label => 'title ascending'
    config.add_sort_field 'pub_date_isi asc, title_si asc', :label => 'year ascending'
    config.add_sort_field 'author_si desc, title_si desc', :label => 'author descending'
    config.add_sort_field 'title_si desc, pub_date_isi desc', :label => 'title descending'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

end 
