FactoryGirl.define do
  factory :article_revision do
    sequence(:version) {|n| n }
    sequence(:received) {|n| "#{n}-01-2016" }
    pages 5
    submission
    article Rails.root.join("spec/features/files/plik.pdf").open
  end
end
