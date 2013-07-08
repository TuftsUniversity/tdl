require 'spec_helper'
feature 'Visitor goes to homepage and does a search' do

  include TestHelpers

  scenario 'user searches for elections get 3 results' do
      visit root_path
      fill_in 'q', :with=>'elections'
      click_button 'Search'
      page.should have_content "3 Results"
  end

end
