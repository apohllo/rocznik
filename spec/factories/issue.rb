FactoryGirl.define do
  factory :issue do
    sequence(:volume) {|n| n }
    sequence(:year)   {|n| 2007 + n }
  end
end
