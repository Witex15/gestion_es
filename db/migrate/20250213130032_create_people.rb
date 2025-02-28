class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :username
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :phone_number
      t.string :iban
      t.integer :role
      t.references :status, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
