feature "zgłoszenia" do
    scenario "sprawdzenie odnośnika do zgłoszeń" do
	   visit '/submissions/'

    expect(page).to have_css(".btn", text:"Zgłoszone artykuły")
  end
