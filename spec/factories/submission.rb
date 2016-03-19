FactoryGirl.define do
  factory :submission do
    language 'polski'
    status 'nadesłany'
    received '18-01-2016'
    association :person, factory: :editor
    polish_title 'Dlaczego solipsyzm?'
    english_title 'Why solipsism?'
    english_abstract 'In this groundbreaking research we prove, ' +
      'that solipsism is the main answer for all cognitive science questions.'
    english_keywords 'solipsism, cognitive science, mind'
  end
end
