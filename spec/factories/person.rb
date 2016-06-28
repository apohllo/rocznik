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
    name 'Andrzej'
    surname 'Zapracowany'
    sequence(:email) do |index|
      if index == 1
        # connection with :user factory
        'admin@localhost.com'
      else
        "editor_#{index}@localhost.com"
      end
    end
    roles ['redaktor']
    sex 'mężczyzna'
    discipline ['informatyka']
    competence 'sztuczna inteligencja'
  end
end
