require 'rails_helper'
describe "błąd 404" do
  it "sprawdzanie kodu błędu 404" do
    visit "/404"
    
    expect(page.status_code).to eq 404
  end
end

describe "błąd 500" do
  it "sprawdzanie kodu błędu 500" do
    visit "/500"
    
    expect(page.status_code).to eq 500
  end
end
