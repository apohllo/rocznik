FactoryGirl.define do
  factory :uj, class: Institution do
    name 'Uniwersytet Jagielloński'
    association :country, factory: :poland
  end

  factory :mit, class: Institution do
    name 'Massachusetts Institute of Technology'
    association :country, factory: :usa
  end
end

