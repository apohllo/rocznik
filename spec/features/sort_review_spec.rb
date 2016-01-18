require 'rails_helper'

feature "sortowanie recenzji" do
  scenario "zarządzanie numerami bez uprawnień" do
    visit '/people'

    expect(page).to have_content 'Log in'
  end

  context "po zalogowaniu" do
    include_context "admin login"

    scenario "sortowanie recenzji" do
      visit '/reviews'
        page.should have_tag("td:first-child", :text => "03-03-2016")
        page.should have_tag("td:last-child", :text => "02-03-2017")
        page.should have_tag("td:nth-last-child(2)", :text => "02-03-2018")
    end
  end
end
