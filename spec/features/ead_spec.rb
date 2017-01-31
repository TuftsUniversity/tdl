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
    page.should have_text "FOOBAR"
    page.should have_text "FOOBAR"
    page.should have_text "Lorem Ipsum papers, 1897-1933"
    page.should have_text "Title: Lorem Ipsum papers"
    page.should have_text "Dates: 1897-1933"
    page.should have_text "Bulk Dates: bulk"
    page.should have_text "Creator: Ipsum, Lorem, 1850-1933"
    page.should have_text "Call Number: MS999"
    page.should have_text "Size: 585 Cubic Feet, 487 record cartons and 1 document case, 197 digital_objects, 95 audiovisual_media"
    page.should have_text "Language(s): Materials are in English, French, and Russian."
    page.should have_text "Location: Digital Collections and Archives"
    page.should have_text "The Lorem Ipsum papers consist of his personal and professional papers."
    page.should have_text "Diaries cover the years 1910-1933 with a suspicious gap in 1922."
    page.should have_text "This collection is arranged in two series."
    page.should have_text "Lorem Ipsum was born in Peoria, Illinois, in 1850."
    page.should have_text "Open to research."
    page.should have_text "Copyright has been retained by donor. Researchers are responsible for contacting copyright holders."
    page.should have_text "Processed in 2016 by Samantha Redgrave."
    page.should have_text "Gift of Harold Lloyd III, 2016."
    page.should have_text "Although Ipsum's rare books were safely ensconced at Oberlin,"
    page.should have_text "University of Chicago"
    page.should have_text "Adolescence"
    page.should have_text "Advertising"
    page.should have_text "Medford (Mass.)"
    page.should have_text "Lorem Ipsum rare book collection, Cornell University."
    page.should have_text "Lorem Ipsum faculty papers, University of Chicago."
    page.should have_text "Personal papers, 1900-1933"
    page.should have_text "Personal papers consist largely of correspondence and diaries."
    page.should have_text "1.1. Correspondence, 1900-1933"
    page.should have_text "Correspondence with many leading lights of the day,"
    page.should have_text "1.2. Diaries, 1910-1933"
    page.should have_text "Diaries are salacious and gossipy."
    page.should have_text "Professional papers, 1897-1933"
    page.should have_text "Professional papers consists of manuscripts, speeches, notes, and student papers."
    page.should have_text "Speeches are very dull."

    click_link "Diaries, 1910-1933", :exact => false
    page.should have_text "Diaries, 1910-1933"
    page.should have_text "This series is part of Lorem Ipsum papers, 1897-1933"
    page.should have_text "23 Volumes"
    page.should have_text "Diaries are mostly in Russian with some English."
    page.should have_text "Diaries are salacious and gossipy."
    page.should have_text "Diaries are arranged chronologically."
    page.should have_text "Diary 1910"
    page.should have_text "Includes a detailed account of attending Nijinksky's performance of Giselle."
    page.should have_text "3123064475432131"
    page.should have_text "MS999.001.002.00001"
    page.should have_text "Item"
    page.should have_text "Open for research."
    page.should have_text "Names and Subjects"
    page.should have_text "Access and Use"
    page.should have_text "Copyright has been retained by donor."
  end
end
