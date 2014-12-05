class Student < ActiveRecord::Base
	extend Geocoder::Model::ActiveRecord
  require 'csv'

  scope :city_location, -> (city) {where city: city}
  scope :state_location, -> (state) {where state: state}
  scope :country_location, -> (country) {where country: country}

	def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student_hash = row.to_hash # exclude the price field
      student = Student.where(id: student_hash["id"])
      geo = Geocoder.search(student_hash["location"]).first
      if (geo != nil)
        student_hash[:city] = geo.city
        student_hash[:state] = geo.state
        student_hash[:country] = geo.country
      end

      if student.count == 1
        student.first.update_attributes(student_hash)
      else
        Student.create!(student_hash)
      end 
    end 
  end 


def self.search(search)
    find(:all, :conditions => ['city LIKE ? OR state LIKE ? OR country LIKE ?', "#{search}", "#{search}", "#{search}"])
end

end 
