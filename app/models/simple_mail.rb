class SimpleMail
  include ActiveModel::Model
  attr_accessor :addressee, :sender, :subject, :body
end
