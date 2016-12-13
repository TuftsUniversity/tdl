require "spec_helper"
feature 'EAD' do
  include TestHelpers

  before do
    @ead = TuftsEAD.find('tufts:UA069.001.DO.UA015')
    @aspace_ead = TuftsEAD.find('tufts:MS999')
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

  scenario 'MS999 (kitchen sink ASpace EAD) should have a View Finding Aid link;  series should contain items' do
    visit catalog_path(@aspace_ead)
    click_link "View Finding Aid", :exact => false
    page.should have_text "Lorem Ipsum papers, 1897-1933"
    page.should have_text "585 Cubic Feet 487 record cartons and 1 document case, 197 digital_objects, 95 audiovisual_media "
    page.should have_text "Diaries cover the years 1910-1933 with a suspicious gap in 1922."
    page.should have_text "Personal papers, 1900-1933"
    page.should have_text "Personal papers consist largely of correspondence and diaries."
    page.should have_text "1.1. Correspondence, 1900-1933"
    page.should have_text "1.2. Diaries, 1910-1933"
    page.should have_text "Professional papers, 1897-1933"
    page.should have_text "University of Chicago"
    page.should have_text "Adolescence"
    page.should have_text "Lorem Ipsum rare book collection, Cornell University."
    page.should have_text "Lorem Ipsum faculty papers, University of Chicago."
    page.should have_text "Processed in 2016 by Samantha Redgrave."
    page.should have_text "Gift of Harold Lloyd III, 2016."
    click_link "Diaries, 1910-1933", :exact => false
    page.should have_text "Diaries, 1910-1933"
    page.should have_text "This series is part of Lorem Ipsum papers, 1897-1933"
    page.should have_text "23 Volumes"
    page.should have_text "Diaries are salacious and gossipy."
    page.should have_text "Diary 1910"
    page.should have_text "3123064475432131"
    page.should have_text "MS999.001.002.00001"
    page.should have_text "Item"
    page.should have_text "Open for research."
    page.should have_text "Copyright has been retained by donor."
  end
end
