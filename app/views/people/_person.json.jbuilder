json.extract! person, :id, :username, :lastname, :firstname, :email, :phone_number, :iban, :role, :status_id, :address_id, :created_at, :updated_at
json.url person_url(person, format: :json)
