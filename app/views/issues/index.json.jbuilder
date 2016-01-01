json.array!(@issues) do |issue|
  json.extract! issue, :id, :year, :volume
  json.url issue_url(issue, format: :json)
end
