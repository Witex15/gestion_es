json.extract! subject, :id, :slug, :name, :teacher_id, :created_at, :updated_at
json.url subject_url(subject, format: :json)
