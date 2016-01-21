require 'spec_helper'


feature 'Visitor goes directly to a catalog pid' do

  include TestHelpers

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
    page.should have_title "Here and There at Tufts - Tufts Digital Library"
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
    page.should have_selector "//a[ class=\"list-add\"]"
  end

  scenario 'user loads image and tries to download image' do
    visit '/catalog/tufts:UP022.001.001.00001.00005'
    page.find("//a[ class=\"list-add\"]").click
    page.should have_text "My List (1)"
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
    find(:xpath, '//*[@id="2"]/a').click
    page.should have_content "Back to Audio Player"
  end

  scenario 'user loads tufts daily 1' do
    visit '/catalog/tufts:UP029.003.003.00012'
    page.should have_content "Tufts Daily, March 1"
    page.should have_content "1982"
    page.should have_link "The Tufts Daily, 1980-2008"
  end
  scenario 'user loads tufts daily 2' do
    visit '/catalog/tufts:UP029.020.031.00108'
    page.should have_content "Tufts Daily, November 29"
  end
  scenario 'user loads tufts daily 3' do
    visit '/catalog/tufts:UP029.003.003.00014'
    page.should have_content "Tufts Daily, March 3"
  end
  scenario 'user loads generic object' do
    visit '/catalog/tufts:MS115.003.001.00002'
    page.should have_content "Election records candidate name authority records, zipped"
    page.should have_content "Philip Lampi"
    page.should have_content "application/zip"
  end
  scenario 'user loads record context record Bouve Boston School of Phys Ed' do
    visit '/catalog/tufts:RCR00613'
    page.should have_content "Bouvé-Boston School of Physical Therapy and Physical Education, 1942-1964"
    page.should have_content "Department of Occupational Therapy (1942-1964)"
    page.should have_content "Athletic Association, PE Club, PT Club, Dance Group, and Swim Club"
  end
  scenario 'users loads Sample Dance Video' do
    visit '/catalog/tufts:sample007'
    page.should have_content "Sample Dance Video 400 x 300"
    page.should have_content "Unknown Tufts University Student"
    page.should have_link "Dance"
    page.should have_link "Download Video File"
  end
  scenario 'user loads voting record' do
    visit '/catalog/tufts:me.uscongress3.second.1825'
    page.should have_content "searchable collection of election returns from the earliest years of American democracy"
    page.should have_link "Maine 1825 U.S. House of Representatives, District 3, Ballot 2"
    page.should have_xpath "//img[@src='/assets/img/elections.png']"
  end
end
