class Student < ActiveRecord::Base
	require 'csv'
	students = CSV.read('learner-locations - Sheet1.csv')
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      student_hash = row.to_hash # exclude the price field
      student = Student.where(id: student_hash["id"])

      if student.count == 1
        student.first.update_attributes(student_hash)
      else
        Student.create!(student_hash)
      end # end if !product.nil?
    end # end CSV.foreach
  end # end self.import(file)
end # end class

