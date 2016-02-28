include Tufts::ModelMethods
include Tufts::MetadataMethods
include Tufts::DarkArchiveMethods

module ApplicationHelper

  def cache_if (condition, name = {}, opts = {},&block)
    if condition
      cache(name, opts,&block)
    else
      yield
    end
  end

  def collection_has_online_content(pid)

    solr_connection = ActiveFedora.solr.conn
    fq = '{!raw f=collection_id_sim}' + pid
    #&fq={!raw f=field_name}crazy+\"field+value

    response = solr_connection.get 'select', :params => {:fq => fq,:rows=>'1'}
    collection_length = response['response']['docs'].length

    if collection_length > 0
      true
    else
      false
    end
  end

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
    generic_content = @document_fedora.datastreams["GENERIC-CONTENT"].find_by_terms(:item)
    result = ""
    generic_content.each_with_index do |node, index|
      nodeElements={}
      node.elements.each do |element|
       nodeElements[element.name]=element.text
      end
      result+="<tr class=\"manifestRow\">"
      link = '/file_assets/generic/' + pid + "/" + String(index)
      result+="<td class=\"nameCol\"><a class=\"manifestLink\" href=\"#{link}\">#{nodeElements['fileName']}</a></td>"
      result+="<td class=\"mimeCol\">#{nodeElements['mimeType']}</td>"
      result+="</tr>"
    end
    return raw(result)
  end

  def show_streets_link(pid)
    urn = pid.gsub("tufts:","")
#puts "#{urn}"
    del_index = urn.index(".")
#puts "#{del_index}"
    col = urn[0..(del_index-1)];
#jputs "#{col}"
    urn = "tufts:central:dca:" + col + ":" + urn
    return "http://bcd.lib.tufts.edu/view_text.jsp?urn=" + urn
  end

  def show_elections_link(pid)
    return "http://elections.lib.tufts.edu/catalog/" + pid
  end

  def http_referer_uri
    request.env["HTTP_REFERER"] && URI.parse(request.env["HTTP_REFERER"])
  end

  def refered_from_our_site?
    if uri = http_referer_uri
      uri.host == request.host
    end 
  end 

  def render_back_to_overview_link(pid)
    link_to('Back to overview', "/catalog/#{pid}")

  end

end
