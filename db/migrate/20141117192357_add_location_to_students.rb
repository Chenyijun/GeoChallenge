class AddLocationToStudents < ActiveRecord::Migration
  def change
    add_column :students, :location, :string
  end
end
