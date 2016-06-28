FactoryGirl.define do
  factory :author, class: Person do
    name 'Joanna'
    surname 'Kognitywistka'
    # connection with :user factory
    sequence(:email) {|n| "user_#{n}@localhost.com" }
    roles ['autor']
    sex 'kobieta'
    discipline ['kognitywistyka']
    competence 'Arystoteles'
  end

  factory :reviewer, class: Person do
    name 'Anna'
    surname 'Genialna'
    sequence(:email) {|n| "reviewer_#{n}@localhost.com" }
    roles ['recenzent']
    sex 'kobieta'
    discipline ['filozofia']
    competence 'percepcja wzroku'
    reviewer_status 'Recenzuje w terminie'
  end

  factory :editor, class: Person do
    id 3
    name 'Andrzej'
    surname 'Zapracowany'
    email 'admin@localhost.com'
    roles ['redaktor']
    sex 'mężczyzna'
    discipline ['informatyka']
    competence 'sztuczna inteligencja'
    initialize_with do
      Person.find_by_email(email) || new(attributes)
    end
  end
end
