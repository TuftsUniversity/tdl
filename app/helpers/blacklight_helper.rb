module BlacklightHelper
  include Hydra::BlacklightHelperBehavior

  # currently only used by the render_document_partial helper method (below)
  def document_partial_name(document)
    return if document[CatalogController.blacklight_config.show.display_type].nil?
    ModelNameHelper.map_model_name(document[CatalogController.blacklight_config.show.display_type].first).gsub(/^[^\/]+\/[^:]+:/, "").underscore.pluralize
  end


end
