#!/usr/bin/env ruby
# This script updates all models to respect soft delete in their associations

require 'fileutils'

# Get all model files
model_files = Dir.glob(File.join('app', 'models', '*.rb'))

model_files.each do |file|
  next if file.include?('application_record.rb')
  
  content = File.read(file)
  
  # Update has_many, has_one, and belongs_to associations to respect soft delete
  updated_content = content.gsub(/(has_many|has_one|belongs_to) :(\w+)/) do |match|
    if match.include?('-> {')
      match
    else
      "#{$1} :#{$2}, -> { where(deleted_at: nil) }"
    end
  end
  
  # Write the updated content back to the file
  File.write(file, updated_content)
  
  puts "Updated #{file}"
end

puts "All models updated for soft delete" 