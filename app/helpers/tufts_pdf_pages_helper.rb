module TuftsPdfPagesHelper
  def convert_url_to_png_path(url, page_number, pid)
logger.warn("#{url} == #{page_number} == #{pid}")
    local_object_store = String.new
    local_object_store = Settings.png_pages.page_location

logger.warn("#{url} == #{page_number} == #{pid}")
    if local_object_store.match(/^\#\{Rails.root\}/)
      local_object_store = "#{Rails.root}" + local_object_store.gsub("\#\{Rails.root\}", "")
    end

    page_part = "-#{page_number}.png"
#logger.warn("#{url} == #{page_number} == #{pid}")
    url = url.gsub('.archival.pdf', page_part)
#logger.warn("#{url} == #{page_number} == #{pid}")
    pid = pid.gsub('tufts:', '')
#logger.warn("#{url} == #{page_number} == #{pid}")
    url = url.insert url.rindex('/')+1, pid + '/'
#logger.warn("#{url} == #{page_number} == #{pid}")
    url = url.gsub(Settings.trim_bucket_url, "")
#logger.warn("#{url} == #{page_number} == #{pid}")

#logger.warn("111 #{url} == #{page_number} == #{pid}")
    url = local_object_store + "/dcadata02" + url[url.index("/",1)..url.length]
#logger.warn("2222 #{url} == #{page_number} == #{pid}")


    url = url.gsub('archival_pdf', 'access_pdf_pageimages')
#logger.warn("#{url} == #{page_number} == #{pid}")
    return url
  end

  def convert_url_to_meta_path(url, page_number, pid)
    local_object_store = Settings.png_pages.page_location

    if local_object_store.match(/^\#\{Rails.root\}/)
      local_object_store = "#{Rails.root}" + local_object_store.gsub("\#\{Rails.root\}", "")
    end

    pid = pid.gsub('tufts:', '')

    url = url[0,url.rindex('/')+1]
    url = url.insert url.rindex('/')+1, pid + '/book_meta.json'
    url = url.gsub(Settings.trim_bucket_url, "")
    url = local_object_store + "/dcadata02" + url[url.index("/",1)..url.length]
    url = url.gsub('archival_pdf', 'access_pdf_pageimages')
    return url
  end
end
