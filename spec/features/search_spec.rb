require 'spec_helper.rb'

feature "Looking up games", js: true do
  scenario "finding games" do
    visit '/'
    fill_in "q", with: "2014"
    click_on "Search"

    expect(page).to have_content("2014")
  end
end
