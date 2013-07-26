include Tufts::ModelMethods
include Tufts::MetadataMethods

module ApplicationHelper

  def http_referer_uri
    request.env["HTTP_REFERER"] && URI.parse(request.env["HTTP_REFERER"])
  end

  def refered_from_our_site?
    if uri = http_referer_uri
      uri.host == request.host
    end 
  end 

  def render_back_to_overview_link
    link_to('Back to overview', catalog_url)

  end



end
