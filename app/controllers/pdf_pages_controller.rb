class PdfPagesController < CatalogController
  include Hydra::AccessControlsEnforcement
  include Blacklight::SolrHelper
  include TuftsPdfPagesHelper


  def dimensions
    @file_asset = FileAsset.find(params[:id])
    if (@file_asset.nil?)
      logger.warn("No such file asset: " + params[:id])
      flash[:retrieval]= "No such file asset."
      redirect_to(:action => 'index', :q => nil, :f => nil)
    else
      # get containing object for this FileAsset
      pid = @file_asset.container_id
      @downloadable = false
      # A FileAsset is downloadable iff the user has read or higher access to a parent
      @response, @permissions_solr_document = get_solr_response_for_doc_id(pid)
      if reader?
        @downloadable = true
      end

      # mapped_model_names = ModelNameHelper.map_model_names(@file_asset.relationships(:has_model))
      # pdf_pages = Settings.pdfpages.pagelocation
      #file name format PB.002.001.00001-0.png
      # pid-pagenumber.png
      # /pdf_pages/data05/tufts/central/dca/PB/access_pdf_pageimages/PB.002.001.00001
      # /pdf_pages/data05/tufts/central/dca/PB/access_pdf_pageimages/PB.002.001.00001

      send_file(convert_url_to_meta_path(@file_asset.datastreams["Archival.pdf"].dsLocation, params[:pageNumber], params[:id]))
    end
  end

  def show
    @file_asset = TuftsBase.find(params[:id])
    if (@file_asset.nil?)
      logger.warn("No such file asset: " + params[:id])
      flash[:retrieval]= "No such file asset."
      redirect_to(:action => 'index', :q => nil, :f => nil)
    else
      if isUnderEmbargo || isMissingCommunityMemberRole
        redirect_to(:root, :q => nil, :f => nil) and return false
      end
      # get containing object for this FileAsset
      pid = @file_asset.pid
      @downloadable = false
      # A FileAsset is downloadable iff the user has read or higher access to a parent
      @response, @permissions_solr_document = get_solr_response_for_doc_id(pid)
      if reader?
        @downloadable = true
      end

      # mapped_model_names = ModelNameHelper.map_model_names(@file_asset.relationships(:has_model))
      # pdf_pages = Settings.pdfpages.pagelocation
      #file name format PB.002.001.00001-0.png
      # pid-pagenumber.png
      # /pdf_pages/data05/tufts/central/dca/PB/access_pdf_pageimages/PB.002.001.00001
      dsLocation = @file_asset.datastreams["Archival.pdf"].dsLocation
      local_path = convert_url_to_png_path(dsLocation, params[:pageNumber], params[:id])

      send_file(local_path)
    end
  end

  private

  def isMissingCommunityMemberRole

    return unless @file_asset.datastreams["DCA-ADMIN"].visibility.include? "authenticated"

    if current_user.nil?
      return true
    end

    if !current_user.nil? and !current_user.has_role? :community_member
      return true
    end

  end

  def isUnderEmbargo
    if @file_asset.datastreams["DCA-ADMIN"].under_embargo?
      logger.warn("File asset embargoed: " + params[:id])
      flash[:retrieval]= "File asset embargoed."
      return true
    end

  end

end
