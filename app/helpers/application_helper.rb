include Tufts::ModelMethods
include Tufts::MetadataMethods

module ApplicationHelper

  def showPdfImage(pid)
    result = "<img alt=\"\" src=\"/pdf_pages/" + pid + "/0\"/>"

    return raw(result)
  end

  def showImage(pid)
      result = "<img alt=\"\" src=\"" + file_asset_path(pid) + "\"/>"

      return raw(result)
  end

  def render_image_viewer_path(pid)
    imageviewer_path(pid) +"#page/1/mode/1up"
  end

  def render_image_viewer_link(pid)
    result = "<a href=\"" + render_image_viewer_path(pid) + "\"><h6>open in viewer <i class=\"icon-share\"></i></h6></a>"
    return raw(result)
  end

  def render_book_viewer_path(pid)
    "/bookreader/" + pid +"#page/1/mode/2up"
  end

  def render_book_viewer_link(pid)
    result = "<a href=\"" + render_book_viewer_path(pid) + "\"><h6>open in viewer <i class=\"icon-share\"></i></h6></a>"
    return raw(result)
  end

  def render_tei_viewer_link(pid)
    result = "<a href=\"" + render_tei_viewer_path(pid) + "\"><h6>View Book <i class=\"icon-share\"></i></h6></a>"
    return raw(result)
  end

  def render_tei_viewer_path(pid)
    "/catalog/tei/" + pid
  end

  #http://ap.rubyonrails.org/classes/ActionController/Streaming.html#M000045
  def showGenericObjects(pid)
    generic_content = get_values_from_datastream(@document_fedora, "GENERIC-CONTENT", [:item])
    result = ""
    generic_content.each_with_index do |page, index|
      result+="<tr class=\"manifestRow\">"
      file_name = get_values_from_datastream(@document_fedora, "GENERIC-CONTENT", [:item, :fileName])[index]
      link = '/file_assets/generic/' + pid + "/" + String(index)
      mime_type = get_values_from_datastream(@document_fedora, "GENERIC-CONTENT", [:item, :mimeType])[index]
      result+="<td class=\"nameCol\"><a class=\"manifestLink\" href=\"#{link}\">#{file_name}</a></td>"
      result+="<td class=\"mimeCol\">#{mime_type}</td>"
      result+="</tr>"
    end
    return raw(result)
  end

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
