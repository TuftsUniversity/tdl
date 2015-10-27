require 'spec_helper'

describe TuftsPdfPagesHelper  do
  it 'should properly remove the namespace from draft objects' do
    helper.send(:remove_pid_namespace, 'draft:sd.1').should == 'sd.1'
  end

  it 'should properly remove the namespace from a published object' do
    helper.send(:remove_pid_namespace, 'tufts:sd.1').should == 'sd.1'
  end

  it 'should successfully convert a bucket url to a png path for a draft object' do


    helper.convert_url_to_png_path('http://bucket01.lib.tufts.edu/data05/tufts/central/dca/UA015/archival_pdf/sd.0000342.archival.pdf', 0, 'draft:sd.0000342').should ==
        Rails.root.to_s + '/pdf_pages/dcadata02' + '/tufts/central/dca/UA015/access_pdf_pageimages/sd.0000342/sd.0000342-0.png'
  end

  it 'should successfully convert a bucket url to a png path for a published object' do
    helper.convert_url_to_png_path('http://bucket01.lib.tufts.edu/data05/tufts/central/dca/UA015/archival_pdf/sd.0000342.archival.pdf', 0, 'tufts:sd.0000342').should ==
        Rails.root.to_s + '/pdf_pages/dcadata02' + '/tufts/central/dca/UA015/access_pdf_pageimages/sd.0000342/sd.0000342-0.png'
  end
end
