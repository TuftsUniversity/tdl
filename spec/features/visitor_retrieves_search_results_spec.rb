require 'spec_helper'
feature 'Visitor goes to homepage and does a search' do

  include TestHelpers

  scenario 'user searches for elections get 7 results' do
      visit root_path
      fill_in 'q', :with=>'elections'
      click_button 'Search'
      page.should have_content "7 Results"
      page.should have_title "Tufts Digital Library Search Results"
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

  scenario 'user searches for author basic' do
      visit root_path
      select 'Creator/Author', :from=> 'search_field'
      fill_in 'q', :with=>'Lewis'
      click_button 'Search'
      page.should have_content "1 Result"
      page.should have_content "You searched for:"
      page.should have_content "Here and There at Tufts"
  end
  scenario 'user searches for subject basic' do
      visit root_path
      select 'Subject', :from=> 'search_field'
      fill_in 'q', :with=>'Hamilton'
      click_button 'Search'
      page.should have_content "1 Result"
      page.should have_content "You searched for:"
      page.should have_content "Portraits of President Hamilton"
  end
  scenario 'user searches for collection advanced' do
      visit root_path
      click_link 'Advanced Search'
      within("div#advanced_search") do
        find_field('collection', :type=> 'text').set('boston')
      end
      click_button 'advanced_search'
      page.should have_content "3 Results"
      page.should have_content "You searched for:"
      page.should have_content "Acceptance Speech for the Citation of Merit Award"
  end

  scenario 'user searches by dates advanced' do
      visit root_path
      click_link 'Advanced Search'
      within ("div#advanced_search") do
        find_field('year_start', :type=> 'number').set('1980')
        find_field('year_end', :type=> 'number').set('1982')
      end
      click_button 'advanced_search'
      page.should have_content "4 Results"
      page.should have_content "Year Start"
      page.should have_content "Tufts Daily, March 1"
  end
end
