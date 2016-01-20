json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :person_id, :article_revision_id
  json.url comment_url(comment, format: :json)
end
