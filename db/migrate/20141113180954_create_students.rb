class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :state
      t.string :country
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
