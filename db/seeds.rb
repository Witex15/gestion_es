# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear existing data
puts "Cleaning database..."
[Grade, Examination, Course, StudentsClass, SchoolClass, PromotionAssert, Person, Status, Address, Room, Subject, Sector, Moment].each(&:destroy_all)

puts "Creating seed data..."

# Create Statuses
puts "Creating statuses..."
student_status = Status.create!(title: "Student", name: "Student", slug: "student")
teacher_status = Status.create!(title: "Teacher", name: "Teacher", slug: "teacher")
admin_status = Status.create!(title: "Administrator", name: "Administrator", slug: "admin")

# Create Dean (Administrator)
puts "Creating dean..."
dean = Person.create!(
  username: "dean.admin",
  lastname: "Smith",
  firstname: "John",
  email: "dean@school.com",
  phone_number: "0791234567",
  iban: "CH93 0076 2011 6238 4295 7",
  role: 2,  # Admin role
  status: admin_status,
  address: Address.create!(
    zip: 1400,
    town: "Yverdon-les-Bains",
    street: "Route de Cheseaux",
    number: "1"
  ),
  password: "admin123"  # Default password for testing
)

# Create Addresses
puts "Creating addresses..."
addresses = []
10.times do
  addresses << Address.create!(
    zip: Faker::Number.number(digits: 4),
    town: Faker::Address.city,
    street: Faker::Address.street_name,
    number: Faker::Address.building_number
  )
end

# Create Rooms
puts "Creating rooms..."
rooms = []
['A101', 'B202', 'C303', 'D404', 'E505'].each do |room_name|
  rooms << Room.create!(name: room_name)
end

# Create Subjects
puts "Creating subjects..."
subjects = []
[
  { name: 'Mathematics', slug: 'math' },
  { name: 'Physics', slug: 'phys' },
  { name: 'Computer Science', slug: 'cs' },
  { name: 'English', slug: 'eng' },
  { name: 'History', slug: 'hist' }
].each do |subject|
  subjects << Subject.create!(subject)
end

# Create Sectors
puts "Creating sectors..."
sectors = []
['Information Technology', 'Business Administration', 'Healthcare'].each do |sector_name|
  sectors << Sector.create!(name: sector_name)
end

# Create Moments (Semesters)
puts "Creating moments..."
moments = []
[
  { uid: 'S2024-1', start_on: '2024-02-01', end_on: '2024-07-31', moment_type: 0 },
  { uid: 'S2024-2', start_on: '2024-08-01', end_on: '2024-12-31', moment_type: 0 }
].each do |moment|
  moments << Moment.create!(moment)
end

# Create Teachers
puts "Creating teachers..."
teachers = []
5.times do
  teachers << Person.create!(
    username: Faker::Internet.unique.username,
    lastname: Faker::Name.last_name,
    firstname: Faker::Name.first_name,
    email: Faker::Internet.unique.email,
    phone_number: Faker::PhoneNumber.cell_phone,
    iban: Faker::Bank.iban,
    role: 1,
    status: teacher_status,
    address: addresses.sample,
    password: 'password123' # Default password for testing
  )
end

# Create Students
puts "Creating students..."
students = []
20.times do
  students << Person.create!(
    username: Faker::Internet.unique.username,
    lastname: Faker::Name.last_name,
    firstname: Faker::Name.first_name,
    email: Faker::Internet.unique.email,
    phone_number: Faker::PhoneNumber.cell_phone,
    iban: Faker::Bank.iban,
    role: 0,
    status: student_status,
    address: addresses.sample,
    password: 'password123' # Default password for testing
  )
end

# Create School Classes
puts "Creating school classes..."
school_classes = []
sectors.each do |sector|
  2.times do |i|
    school_classes << SchoolClass.create!(
      name: "#{sector.name[0..2]}-#{i + 1}",
      moment: moments.first,
      room: rooms.sample,
      master: teachers.sample,
      sector: sector
    )
  end
end

# Assign Students to Classes
puts "Assigning students to classes..."
students.each do |student|
  StudentsClass.create!(
    student: student,
    school_class: school_classes.sample
  )
end

# Create Courses
puts "Creating courses..."
courses = []
school_classes.each do |school_class|
  subjects.each do |subject|
    courses << Course.create!(
      start_at: "08:00",
      end_at: "09:30",
      archived: false,
      subject: subject,
      school_class: school_class,
      moment: moments.first,
      teacher: teachers.sample,
      week_day: rand(1..5)
    )
  end
end

# Create Examinations and Grades
puts "Creating examinations and grades..."
courses.each do |course|
  2.times do |i|
    examination = Examination.create!(
      title: "#{course.subject.name} Exam #{i + 1}",
      effective_date: Faker::Date.between(from: course.moment.start_on, to: course.moment.end_on),
      course: course
    )
    
    # Create grades for each student in the class
    course.school_class.students.each do |student|
      Grade.create!(
        value: rand(1..6),
        execute_on: examination.effective_date,
        examination: examination,
        student: student
      )
    end
  end
end

# Create Promotion Asserts
puts "Creating promotion asserts..."
sectors.each do |sector|
  moments.each do |moment|
    PromotionAssert.create!(
      description: "#{sector.name} requirements for #{moment.uid}",
      function: "min_grade_4",
      moment: moment,
      sector: sector
    )
  end
end

puts "Seed completed successfully!"
