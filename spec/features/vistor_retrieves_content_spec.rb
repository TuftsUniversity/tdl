require 'spec_helper'


feature 'Visitor goes directly to a catalog pid' do

  include TestHelpers
#tufts_ky.clerkofthehouse.1813.foxml.xml
#tufts_la.speakerofthehouse.1820.foxml.xml
#tufts_me.uscongress3.second.1825.foxml.xml
#tufts_MS054.003.DO.02108.foxml.xml
#tufts_MS115.003.001.00001.foxml.xml
#tufts_MS115.003.001.00002.foxml.xml
#tufts_MS115.003.001.00003.foxml.xml
#tufts_MS122.002.001.00130.foxml.xml
#tufts_MS122.002.004.00025.foxml.xml
#tufts_MS122.002.021.00084.foxml.xml
#tufts_MS124.001.001.00002.foxml.xml
#tufts_MS124.001.001.00003.foxml.xml
#tufts_MS124.001.001.00006.foxml.xml
#tufts_PB.002.001.00001.foxml.xml
#tufts_PB.005.001.00001.foxml.xml
#tufts_RCR00001.foxml.xml
#tufts_RCR00613.foxml.xml
#tufts_RCR00728.foxml.xml
#tufts_sample001.foxml.xml
#tufts_sample002.foxml.xml
#tufts_TBS.VW0001.000113.foxml.xml
#tufts_TBS.VW0001.000386.foxml.xml
#tufts_TBS.VW0001.002493.foxml.xml
#tufts_UA015.012.DO.00104.foxml.xml
#tufts_UA069.001.DO.MS019.foxml.xml
#tufts_UA069.001.DO.MS043.foxml.xml
#tufts_UA069.001.DO.MS056.foxml.xml
#tufts_UA069.001.DO.MS134.foxml.xml
#tufts_UA069.001.DO.UA001.foxml.xml
#tufts_UA069.001.DO.UA015.foxml.xml
#tufts_UA069.001.DO.UP029.foxml.xml

  #Note that for this object, the images required for the viewer are not in the reference set
  scenario 'user loads Alliance for Progress fletcher thesis, and sees that it is in the collection: Fletcher School of Law and Diplomacy records, 1923-2003' do
    visit '/catalog/tufts:UA015.012.DO.00104'
    page.should have_content 'Fletcher School of Law and Diplomacy records, 1923-2003'
  end

  scenario 'user is on Alliance for Progress fletcher thesis, and clicks through to see the parent collection' do
    visit '/catalog/tufts:UA015.012.DO.00104'
    click_link 'Fletcher School of Law and Diplomacy records, 1923-2003'
    page.status_code.should be 200
    page.should have_content "58.25 Linear feet"
    page.should have_link "View Finding Aid"
    page.should have_link "View Online Materials"
    click_link 'View Finding Aid'
    page.should have_content "Russell Miller in his research for Light on the Hill"
    page.should have_link "General subject files, 1923-96 1923-96"
    click_link 'General subject files, 1923-96 1923-96'
    page.should have_content "Clippings, 1948-81"
end

  scenario 'user loads Here and There at Tufts' do
    visit '/catalog/tufts:UA069.005.DO.00094'
    #checking table of contents
    page.should have_content 'Frontispiece'
  end
  scenario 'user loads A Failure of Management' do
    visit '/catalog/tufts:UA069.005.DO.00239'
    page.should have_content 'This document was created from the article, "A Failure of Management" by Walter B. Wriston for the 1995 edition of "Sternbusiness." The original article is located in MS134.003.028.00013.'
  end

  scenario 'user loads A Long View of the Short Run: An Address and opens book' do
    visit '/catalog/tufts:UA069.005.DO.00272'
    page.should have_content "The document was created from the speech,"
    click_link 'View Book'
    page.status_code.should be 200
  end

  scenario 'user loads tei' do
    visit '/catalog/tufts:UA069.005.DO.00339'
    page.should have_content "Acceptance Speech for the Citation of Merit Award"
  end

  scenario 'user loads image' do
    visit '/catalog/tufts:UP022.001.001.00001.00005'
    page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855"
    page.should have_xpath "//img[@src=\"/file_assets/tufts:UP022.001.001.00001.00005\"]"
  end

  scenario 'user loads image and goes to request hi res version' do
    visit '/catalog/tufts:UP022.001.001.00001.00005'
    href = "http://sites.tufts.edu/dca/research-help/image-requests/"
    page.should have_selector "a[href='#{href}']", text: "Request High-resolution"
  end

  scenario 'user loads image and tries to download image' do
    visit '/catalog/tufts:UP022.001.001.00001.00005'
    click_link 'Download Image'
    page.status_code.should be 200
  end

  scenario 'user loads advanced image viewer' do
    visit '/imageviewer/tufts:UP022.001.001.00001.00005#page/1/mode/1up'
    page.status_code.should be 200
  end

  scenario 'user loads drumming audio' do
    visit '/catalog/tufts:MS122.002.021.00084'
    page.should have_content 'Baamaaya Baamaaya lead lunga drum language audio'
    page.should have_link "African drumming"
  end

  scenario 'user loads oral history' do
    visit '/catalog/tufts:MS124.001.001.00002'
    page.should have_content 'Lost Theaters of Somerville: Edward Ciampa Interview'
    page.should have_content "you call them the Loony Tunes"
    page.should have_content "Adrienne Effron, interviewer (female)"
  end

  scenario 'user loads tufts daily' do
    visit '/catalog/tufts:UP029.003.003.00012'
    page.should have_content "Tufts Daily, March 1"
    page.should have_content "1982"
    page.should have_link "The Tufts Daily, 1980-2008"
  end
  scenario 'user loads tufts daily' do
    visit '/catalog/tufts:UP029.020.031.00108'
    page.should have_content "Tufts Daily, November 29"
  end
  scenario 'user loads tufts daily' do
    visit '/catalog/tufts:UP029.003.003.00014'
    page.should have_content "Tufts Daily, March 3"
  end
  scenario 'user wildlife pathology image' do
    visit '/catalog/tufts:WP0001'
    page.should have_content "Example Wildlife Pathology entry"
  end
  scenario 'user loads generic object' do
    visit '/catalog/tufts:MS115.003.001.00002'
    page.should have_content "Election records candidate name authority records, zipped"
    page.should have_content "Philip Lampi"
    page.should have_content "application/zip"
  end

  scenario 'user loads image text' do
    visit '/catalog/tufts:sample001'
    page.should have_content "Example HTML entry"
    page.should have_content "Goodmon, Brian"
    page.should have_link "Identifying Organs by Color"
  end
end
