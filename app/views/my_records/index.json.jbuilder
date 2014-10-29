json.array!(@my_records) do |my_record|
  json.extract! my_record, :id, :name
  json.url my_record_url(my_record, format: :json)
end
