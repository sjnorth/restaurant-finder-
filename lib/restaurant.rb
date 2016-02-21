require 'support/number_helper'
class Restaurant
	include NumberHelper

	@@filepath = nil
def self.filepath=(path=nil)
	@@filepath = File.join(APP_ROOT, path)
	#this allows us to call the filepath from outside 
	#the class (i.e. for this case in the 'guide' file)
	attr_accessor :name, :cuisine, :price
end
	def self.file_exists?
		# because the class should know if the restaurant file exists
		if @@filepath && File.exists?(@@filepath)
		return true
		else
		return false
		end 
	end 

	def self.file_usable? #runs a series of tests on @@filepath
		return false unless @@filepath
		return false unless File.exists?(@@filepath)
		return false unless File.readable?(@@filepath)
		return false unless File.writable?(@@filepath)
		return true #if all above conditions are met, 
		#then the file is deemed usable, i.e. true.
	end 

	def self.create_file
		# this creates the restaurant file 
		File.open(@@filepath, 'w') unless file_exists?
		return file_usable #this will return a boolean value 
		# which can be used to pass the file_usable test
	end

	def self.saved_restaurants
		# read the restaurant file
		# return instances of restaurant
		restaurants = []
		if file_usable?
			file = File.new(@@filepath, 'r')
			file.each_line do |line|
				
				restaurants << Restaurant.new.import_line(line.chomp)
			end 
			file.close
		end
		return restaurants 
	end

	def self.build_using_questions
		args = {}
		print "Restaurant Name: "
		args[:name] = gets.chomp.strip

		print "Cuisine Type: "
		args[:cuisine] = gets.chomp.strip

		print "Average Price: "
		args[:price] = gets.chomp.strip

		return self.new(args)
	end

	def initialize(args={})
		@name    = args[:name]    || ""
		@cuisine = args[:cuisine] || ""
		@price   = args[:price]   || ""
	end 

	def import_line(line)
		line_array = line.split("\t")
		@name, @cuisine, @price = line_array
		return self 
	end

#NB it's good practice to have all class methods placed up top, followed by instance methods below this line
	
	def save
		return false unless Restaurant.file_usable?
		File.open(@@filepath, 'a') do |file|
			file.puts "#{[@name, @cuisine, @price].join("\t")}\n"
		end
		return true
	end

	def formatted_price
		number_to_currency(@price)
	end

end