class Student < ActiveRecord::Base
	extend Geocoder::Model::ActiveRecord
	#before_validation :get_location_coordinates	
  require 'csv'
	students = CSV.read('learner-locations - Sheet1.csv')

	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student_hash = row.to_hash # exclude the price field
      student = Student.where(id: student_hash["id"])
      coord = Geocoder.coordinates(student_hash["location"])
      student_hash[:latitude] = coord[0]
      student_hash[:longitude] = coord[1]

      query = "#{coord[0]}" + "," + "#{coord[1]}"

      geo = Geocoder.search(query).first
      if geo == nil
        #if location cant be found, be less specific
        r = 7
        while (geo==nil && r>=0)
          newQuery = "#{coord[0].round(r)}" + "," + "#{coord[1].round(r)}"
          r-=3
          geo = Geocoder.search(newQuery).first
        end
      end
        student_hash[:city] = geo.city
        student_hash[:state] = geo.state
        student_hash[:country] = geo.country

      if student.count == 1
        student.first.update_attributes(student_hash)
      else
        Student.create!(student_hash)
      end # end if !product.nil?
    end # end CSV.foreach
  end # end self.import(file)

  def get_location_coordinates
    sleep 1
    coord = Geocoder.coordinates("#{self.location}")
    if coord
      self.latitude = coord[0]
      self.longitude = coord[1]
    else 
      errors.add(:base, "Error with geocoding")
    end
    coord
  end

end # end class
