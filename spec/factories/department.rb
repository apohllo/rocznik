FactoryGirl.define do
  factory :psychology_at_uj, class: Department do
    name 'Instytut Psychologii'
    association :institution, factory: :uj
  end

  factory :psychology_at_mit, class: Department do
    name 'Department of Psychology'
    association :institution, factory: :mit
  end
end
