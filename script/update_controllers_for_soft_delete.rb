#!/usr/bin/env ruby
# This script updates all controllers to use soft delete functionality

require 'fileutils'

# Get all controller files
controller_files = Dir.glob(File.join('app', 'controllers', '**', '*.rb'))

controller_files.each do |file|
  next if file.include?('application_controller.rb') || file.include?('concerns/')
  
  puts "Processing #{file}..."
  
  # Read the file content
  content = File.read(file)
  
  # Replace destroy! with destroy for soft delete
  updated_content = content.gsub(/destroy!/, 'destroy')
  
  # Change "successfully destroyed" messages to "successfully deleted"
  updated_content = updated_content.gsub(/successfully destroyed/, 'successfully deleted')
  
  # Add .active scope to model queries in index actions
  updated_content = updated_content.gsub(/def set_(\w+)\n\s+@\1 = (\w+)\.find\(params\[:id\]\)/) do
    "def set_#{$1}\n    @#{$1} = #{$2}.active.find(params[:id])"
  end
  
  # Update index actions to use active scope
  updated_content = updated_content.gsub(/def index\n\s+@(\w+) = (\w+)\.all/) do
    "def index\n    @#{$1} = #{$2}.active.all"
  end
  
  # Write the updated content back to the file
  File.write(file, updated_content)
  
  puts "Updated #{file}"
end

puts "All controllers updated for soft delete" 