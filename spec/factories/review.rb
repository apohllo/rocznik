FactoryGirl.define do
  factory :review do
    status 'recenzja pozytywna'
    content 'To bardzo dobry artykuł'
    sequence(:asked) {|n| "#{n}-02-2016" }
    sequence(:deadline) {|n| "#{n}-03-2016" }
    association :person, factory: :reviewer
    article_revision
  end
end
