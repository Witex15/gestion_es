class CreateStudentsClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :students_classes do |t|
      t.references :student, null: false, foreign_key: { to_table: :people }
      t.references :school_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
