class Student < ActiveRecord::Base
	extend Geocoder::Model::ActiveRecord
	before_validation :get_location_coordinates
  before_validation :reverse_geocode 
	
  require 'csv'
	students = CSV.read('learner-locations - Sheet1.csv')

	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student_hash = row.to_hash # exclude the price field
      student = Student.where(id: student_hash["id"])
      print student
      print student_hash

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

  def reverse_geocode 
  	#reverse_geocoded_by :latitude, :longitude do |obj, results|
    query = :latitude.to_s + "," + :longitude.to_s
  		#if geo = results.first
      if geo = Geocoder.search(query).first
        print geo
  			obj.locality = geo.city
        print obj.locality
        print geo.city
  			obj.adminDistrict = geo.state
        print obj.adminDistrict
        print geo.state
  			obj.countryRegion = geo.country
        print obj.countryRegion
        print geo.country
  		end
    #end
  end

end # end class
