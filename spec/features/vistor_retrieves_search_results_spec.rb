require 'spec_helper'
feature 'Visitor goes to homepage and does a search' do

  include TestHelpers

  scenario 'user searches for elections get 3 results' do
      visit root_path
      fill_in 'q', :with=>'elections'
      click_button 'Search'
      page.should have_content "3 Results"
  end

  scenario 'user searches for title advanced' do
      visit root_path
      click_link 'Advanced Search'
      within("div#advanced_search") do
        find_field('title', :type=> 'text').set('ciampa')
        find_field('title', :type=> 'text').value.should eq 'ciampa'
      end
      click_button 'advanced_search'
      page.should have_content "1 Result"
      page.should have_content "You searched for:"
      page.should have_content "Adrienne Effron"
  end

end
