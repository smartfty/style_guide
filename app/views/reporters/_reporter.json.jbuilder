json.extract! reporter, :id, :name, :email, :division, :title, :created_at, :updated_at
json.url reporter_url(reporter, format: :json)
