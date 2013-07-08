require "spec_helper"
feature  'images that should load but do not, in part because some static pages load images out of the dl, something to keep an eye on.' do
  include TestHelpers

  scenario 'Walter B. Wriston collection image loads' do
      visit root_path
      click_link "Walter B. Wriston collection"
      active_link?("#{Capybara.app_host}:#{Capybara.server_port.to_s}/file_assets/tufts:MS134.006.035.00004").should be
   end

  scenario 'escholarship image loads' do
      visit root_path
      click_link "E-scholarship"
      active_link?("#{Capybara.app_host}:#{Capybara.server_port.to_s}/file_assets/tufts:UA015.001.003.00072.00005").should be
   end

  scenario 'contact page image loads' do
      visit root_path
      click_link "Contact"
      active_link?("#{Capybara.app_host}:#{Capybara.server_port.to_s}/file_assets/tufts:UA009.011.029.00009").should be
   end
end
