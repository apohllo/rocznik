FactoryGirl.define do
  factory :authorship do
    association :person, factory: :author
    association :submission
  end
end
