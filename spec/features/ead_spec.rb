require "spec_helper"
feature 'EAD' do
  include TestHelpers

  before do
    @ead = TuftsEAD.find('tufts:UA069.001.DO.UA015')
  end

  scenario 'View Online Materials should link to associated materials in search results' do
    visit catalog_path(@ead)
    click_link "View Online Materials", :exact => false
    page.should have_text "Alliance for Progress or Alianza Para El Progreso? A Reassessment of the Latin American Contribution to the Alliance for Progress"

  end

  scenario 'from the Finding Aid Viewer, View Online Materials should link to associated materials in search results' do
    visit catalog_path(@ead)
    click_link "View Finding Aid", :exact => false
    click_link "View Online Materials", :exact => false
    page.should have_text "Alliance for Progress or Alianza Para El Progreso? A Reassessment of the Latin American Contribution to the Alliance for Progress"

  end
end
