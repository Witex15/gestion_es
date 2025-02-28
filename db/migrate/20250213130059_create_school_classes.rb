class CreateSchoolClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :school_classes do |t|
      t.string :uid
      t.string :name
      t.references :moment, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.references :master, null: false, foreign_key: true
      t.references :sector, null: false, foreign_key: true

      t.timestamps
    end
  end
end
