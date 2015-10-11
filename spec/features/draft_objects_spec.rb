require 'spec_helper'


feature 'Visitor goes directly to a catalog pid' do

  include TestHelpers


  scenario 'user logs in to see draft content without correct permissions' do
#    visit '/'
#    click_link 'Fletcher School of Law and Diplomacy records, 1923-2003'
#    page.status_code.should be 200
#    page.should have_content "58.25 Linear feet"
#    page.should have_link "View Finding Aid"
#    page.should have_link "View Online Materials"
#    click_link 'View Finding Aid'
#    page.should have_content "Russell Miller in his research for Light on the Hill"
#    page.should have_link "General subject files, 1923-96 1923-96"
#    click_link 'General subject files, 1923-96 1923-96'
#    page.should have_content "Clippings, 1948-81"
     pending("in progress")
  end

  scenario 'digital repository administrator logs in to see draft object' do
     pending("in progress")
#    visit '/catalog/tufts:UA069.005.DO.00094'
    #checking table of contents
#    page.should have_content 'Frontispiece'
#    page.should have_title "Here and There at Tufts - Tufts Digital Library"
  end


end
