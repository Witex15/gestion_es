namespace :setup do
  desc "Create initial dean user and required dependencies"
  task reset_dean: :environment do
    # Create default status if not exists
    status = Status.find_or_create_by!(title: "Active", slug: "active")
    
    # Create default address if not exists
    address = Address.find_or_create_by!(
      zip: "00000",
      town: "Default Town",
      street: "Default Street",
      number: "1"
    )
    
    # Delete existing dean if exists
    Person.where(role: :dean).destroy_all
    
    # Create new dean user
    dean = Person.create!(
      username: "admin",
      lastname: "Administrator",
      firstname: "System",
      email: "admin@school.com",
      password: "Admin123!",
      password_confirmation: "Admin123!",
      role: :dean,
      status: status,
      address: address
    )
    puts "Dean user created successfully!"
    puts "Email: #{dean.email}"
    puts "Password: Admin123!"
  end
  
  desc "Create initial dean user and required dependencies"
  task create_dean: :environment do
    # Create default status if not exists
    status = Status.find_or_create_by!(title: "Active", slug: "active")
    
    # Create default address if not exists
    address = Address.find_or_create_by!(
      zip: "00000",
      town: "Default Town",
      street: "Default Street",
      number: "1"
    )
    
    # Create dean user if no dean exists
    if Person.where(role: :dean).none?
      dean = Person.create!(
        username: "admin",
        lastname: "Administrator",
        firstname: "System",
        email: "admin@school.com",
        password: "Admin123!",
        password_confirmation: "Admin123!",
        role: :dean,
        status: status,
        address: address
      )
      puts "Dean user created successfully!"
      puts "Email: #{dean.email}"
      puts "Password: Admin123!"
    else
      puts "Dean user already exists."
    end
  end
end 