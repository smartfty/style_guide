json.extract! graphic_request, :id, :date, :title, :requester, :person_in_charge, :status, :description, :created_at, :updated_at
json.url graphic_request_url(graphic_request, format: :json)
