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
# Use really_destroy_all instead of destroy_all for seeding
# This completely removes records from the database instead of soft-deleting them
[Grade, Examination, Course, StudentsClass, SchoolClass, PromotionAssert, Person, Status, Address, Room, Subject, Sector, Moment].each do |model|
  model.unscoped.update_all(deleted_at: nil) # Clear any soft-deleted flags first
  model.unscoped.each(&:really_destroy!) # Permanently delete all records
end

puts "Creating seed data..."

# Create Statuses
puts "Creating statuses..."
student_status = Status.create!(title: "Student", name: "Student", slug: "student")
teacher_status = Status.create!(title: "Teacher", name: "Teacher", slug: "teacher")
admin_status = Status.create!(title: "Administrator", name: "Administrator", slug: "admin")

# Create test users for each role (for easy testing)
puts "Creating test users..."
test_address = Address.create!(
  zip: 1400,
  town: "Yverdon-les-Bains",
  street: "Route de Cheseaux",
  number: "1"
)

# Test Dean (Administrator)
dean = Person.create!(
  username: "dean",
  lastname: "Admin",
  firstname: "John",
  email: "dean@school.com",
  phone_number: "0791234567",
  iban: "CH93 0076 2011 6238 4295 7",
  role: 2,  # Admin role
  status: admin_status,
  address: test_address,
  password: "password123"  # Test password
)

# Test Teacher
teacher = Person.create!(
  username: "teacher",
  lastname: "Smith",
  firstname: "Jane",
  email: "teacher@school.com",
  phone_number: "0791234568",
  iban: "CH93 0076 2011 6238 4295 8",
  role: 1,  # Teacher role
  status: teacher_status,
  address: test_address,
  password: "password123"  # Test password
)

# Test Student
student = Person.create!(
  username: "student",
  lastname: "Brown",
  firstname: "Mike",
  email: "student@school.com",
  phone_number: "0791234569",
  iban: "CH93 0076 2011 6238 4295 9",
  role: 0,  # Student role
  status: student_status,
  address: test_address,
  password: "password123"  # Test password
)

# Create Addresses
puts "Creating addresses..."
addresses = []
addresses << test_address # Add the test address to the pool
9.times do
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

# Create Teachers (additional)
puts "Creating additional teachers..."
teachers = [teacher] # Add the test teacher
4.times do
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

# Create Students (additional)
puts "Creating additional students..."
students = [student] # Add the test student
19.times do |i|
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

# Create School Classes for each moment
puts "Creating school classes..."
school_classes = []
moments.each do |moment|
  sectors.each do |sector|
    2.times do |i|
      school_classes << SchoolClass.create!(
        name: "#{sector.name[0..2]}-#{i + 1}-#{moment.uid}",
        moment: moment,
        room: rooms.sample,
        master: teachers.sample,
        sector: sector
      )
    end
  end
end

# Assign Students to Classes (ensure each student is in a class for each moment)
puts "Assigning students to classes..."
students.each do |student|
  moments.each do |moment|
    available_classes = school_classes.select { |sc| sc.moment_id == moment.id }
    StudentsClass.create!(
      student: student,
      school_class: available_classes.sample
    )
  end
end

# Create Courses for all moments
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
      moment: school_class.moment,
      teacher: teachers.sample,
      week_day: rand(1..5)
    )
  end
end

# Create Examinations and Grades with controlled grade distribution
puts "Creating examinations and grades..."
courses.each do |course|
  2.times do |i|
    examination = Examination.create!(
      title: "#{course.subject.name} Exam #{i + 1}",
      effective_date: Faker::Date.between(from: course.moment.start_on, to: course.moment.end_on),
      course: course
    )
    
    # Create grades for each student in the class with controlled distribution
    course.school_class.students.each do |student|
      # First 5 students get good grades (4.5-6.0)
      # Next 10 students get average grades (4.0-5.0)
      # Last 5 students get lower grades (3.0-4.5)
      grade_value = if student.id % 20 < 5
                     rand(4.5..6.0).round(1)  # Top performers
                   elsif student.id % 20 < 15
                     rand(4.0..5.0).round(1)  # Average performers
                   else
                     rand(3.0..4.5).round(1)  # Struggling students
                   end
      
      Grade.create!(
        value: grade_value,
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
      function: ['average_min_4', 'average_min_4.5', 'average_min_5', 'all_passed'].sample,
      moment: moment,
      sector: sector
    )
  end
end

puts "Seed completed successfully!"
