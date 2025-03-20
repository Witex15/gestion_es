class AddDeletedAtToAllTables < ActiveRecord::Migration[8.0]
  def change
    # Add deleted_at column to all tables
    add_column :addresses, :deleted_at, :datetime
    add_column :courses, :deleted_at, :datetime
    add_column :examinations, :deleted_at, :datetime
    add_column :grades, :deleted_at, :datetime
    add_column :moments, :deleted_at, :datetime
    add_column :people, :deleted_at, :datetime
    add_column :promotion_asserts, :deleted_at, :datetime
    add_column :rooms, :deleted_at, :datetime
    add_column :school_classes, :deleted_at, :datetime
    add_column :sectors, :deleted_at, :datetime
    add_column :statuses, :deleted_at, :datetime
    add_column :students_classes, :deleted_at, :datetime
    add_column :subjects, :deleted_at, :datetime
    
    # Add indexes for better query performance
    add_index :addresses, :deleted_at
    add_index :courses, :deleted_at
    add_index :examinations, :deleted_at
    add_index :grades, :deleted_at
    add_index :moments, :deleted_at
    add_index :people, :deleted_at
    add_index :promotion_asserts, :deleted_at
    add_index :rooms, :deleted_at
    add_index :school_classes, :deleted_at
    add_index :sectors, :deleted_at
    add_index :statuses, :deleted_at
    add_index :students_classes, :deleted_at
    add_index :subjects, :deleted_at
  end
end
