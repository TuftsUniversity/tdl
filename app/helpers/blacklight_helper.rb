module BlacklightHelper
  include Hydra::BlacklightHelperBehavior

  # currently only used by the render_document_partial helper method (below)
  def document_partial_name(document)
    return if document[CatalogController.blacklight_config.show.display_type].nil?
    ModelNameHelper.map_model_name(document[CatalogController.blacklight_config.show.display_type].first).gsub(/^[^\/]+\/[^:]+:/, "").underscore.pluralize
  end

  def render_facet_value(facet_solr_field, item, options ={})
    if item.is_a? Array
      link_to_unless(options[:suppress_link], item[0], add_facet_params_and_redirect(facet_solr_field, item[0]), :class => "facet_select") + raw("<span class='number   count'> (" + format_num(item[1]) + ")</span>")
    else
      text_for_link = item.value
      unless options[:suppress_link]
        #link_to_unless(, , :class=>"facet_select") do
        link_to add_facet_params_and_redirect(facet_solr_field, item.value), :class => "facet_select" do
          out = text_for_link

          out +="<span class='numbercount'> ("+ format_num(item.hits) +")</span>"
          out.html_safe
        end
      else
        out = item.value
        out.html_safe
      end

    end
  end

end
