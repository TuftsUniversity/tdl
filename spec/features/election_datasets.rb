require "spec_helper"
feature 'Election Datasets' do
  include TestHelpers


  scenario 'NNV Users clicks over to the TDL to download generic elections data sets for offline processing' do
    visit '/election_datasets'
    page.should have_text "3 Results"
  end
end
