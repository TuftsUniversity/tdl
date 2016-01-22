require 'spec_helper'
feature 'Visitor goes to homepage' do
#    before(:each) do
#      @session = Capybara::Session.new(Capybara.javascript_driver)
#    end
  before(:each) do
    visit "/" # This can be whatever URL you need it to be
    page.execute_script("localStorage.clear()")
  end
  scenario 'clicks to bring up their empty list', :js => true do
       visit root_path
       click_button 'myListButton'
       page.should have_css("div#cart_modal", :visible => true)
       page.should have_text("Your List is empty!")
  end

  scenario 'adds item to list', :js => true do
       visit '/catalog/tufts:UP022.001.001.00001.00005'
       page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855" 
       click_link "Add to List" 
       click_button 'myListButton'
       page.should have_text "My List : 1 Item"
  end

  scenario 'adds item to list, and requests copies', :js => true do
       visit '/catalog/tufts:UP022.001.001.00001.00005'
       page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855" 
       click_link "Add to List" 
       click_button 'myListButton'
       page.should have_text "My List : 1 Item"
       click_button "Request Copies"
       page.should have_text "Reproduction Request"
  end

  scenario 'adds item to list, and requests reading room visit', :js => true do
       visit '/catalog/tufts:UP022.001.001.00001.00005'
       page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855" 
       click_link "Add to List" 
       click_button 'myListButton'
       page.should have_text "My List : 1 Item"
       click_button "Request in Reading Room"
       page.should have_text "Reading Room Request"
  end

  scenario 'adds item to list, and saves in TASCR for later use', :js => true do
       visit '/catalog/tufts:UP022.001.001.00001.00005'
       page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855" 
       click_link "Add to List" 
       click_button 'myListButton'
       page.should have_text "My List : 1 Item"
       click_button "Save in TASCR"
       page.should have_text "Save in TASCR"
  end

  scenario 'adds item to list, and then removes all items from list', :js => true do
       visit '/catalog/tufts:UP022.001.001.00001.00005'
       page.should have_content "Illustration of the Festival at the Dedication of Tufts College on August 22, 1855" 
       click_link "Add to List" 
       click_button 'myListButton'
       page.should have_text "My List : 1 Item"
       page.find_button("Remove all Items from List").trigger('click')
       page.should have_text "Your List is empty!"
  end

end
