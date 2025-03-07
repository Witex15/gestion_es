class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.time :start_at
      t.time :end_at
      t.boolean :archived
      t.references :subject, null: false, foreign_key: true
      t.references :school_class, null: false, foreign_key: true
      t.references :moment, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: { to_table: :people }
      t.integer :week_day

      t.timestamps
    end
  end
end
