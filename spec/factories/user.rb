FactoryGirl.define do
  factory :user do
    email 'user@localhost.com'
    password 'password'
    admin false
  end

  factory :admin, class: User do
    email 'admin@localhost.com'
    password  'password1'
    admin      true
  end
end
