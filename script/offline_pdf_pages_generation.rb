# this file contains some utility routines for generating pdf pages locally on your laptop and moving them back to
# TDL.  Previouly I just loaded these files into rails console and did some quick conversions with it, would need more work
# if it ever got used regularly

require 'RMagick'

def convert_pdf_to_pages_locally(path_to_file)
  pdf_path = ''
  pdf_pages = Magick::Image.read(path_to_file) { self.density = '150x150' }
  page_count = pdf_pages.length
  page_width = pdf_pages[0].columns
  page_height = pdf_pages[0].rows
  id = File.basename(path_to_file, ".archival.pdf")

  meta_path = File.dirname(path_to_file) + "/output/" + id + '/book_meta.json'
  meta_path_dir = File.dirname(meta_path)
  FileUtils.mkdir_p(meta_path_dir)

  json = '{"page_width":"' + page_width.to_s + '","page_height":"' + page_height.to_s + '","page_count":"' + page_count.to_s + '"}'

  File.open(meta_path, 'w') { |file| file.puts(json) }
  readme_path = meta_path_dir + '/readme.txt'

  readme = 'Created by pngizer from source: ' + pdf_path


  File.open(readme_path, 'w') { |file| file.puts(readme) }
  page_number = 0

  pdf_pages.each do |pdf_page|
    png_path = convert_url_to_png_path(path_to_file, page_number)
    pdf_page.write(png_path) { self.quality = 100 }
    pdf_page.destroy! # this is important - without it RMagick can occasionally be left in a state that causes subsequent failures
    pdf_pages[page_number] = nil
    page_number += 1
  end

end

def convert_url_to_png_path(path_to_file,page_number)

  id = File.basename(path_to_file, ".archival.pdf")
  page_part = "-#{page_number}.png"
  meta_path = File.dirname(path_to_file) + "/output/" + id + '/' + id + page_part



  return meta_path
end
