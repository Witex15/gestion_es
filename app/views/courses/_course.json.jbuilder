json.extract! course, :id, :start_at, :end_at, :archived, :subject_id, :school_class_id, :moment_id, :teacher_id, :week_day, :created_at, :updated_at
json.url course_url(course, format: :json)
