class AddNameToStatuses < ActiveRecord::Migration[8.0]
  def change
    add_column :statuses, :name, :string
  end
end
