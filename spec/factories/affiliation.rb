FactoryGirl.define do
  factory :affiliation, class: Affiliation do
    year_from '2000'
    year_to '2015'
    association :person, factory: :reviewer
    association :department, factory: :psychology_at_uj
  end
end
