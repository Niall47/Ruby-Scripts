	require 'json'
	require 'colorize'
	require_relative "extra_functions"

	class Car
	  attr_accessor :vrm
	  attr_accessor :make
	  attr_accessor :model
	  attr_accessor :description
	  attr_accessor :colour
	  attr_accessor :date

	  def initialize(aMake, aModel, aDescription, aColour, aVRM, aManufactureDate)
		@vrm = aVRM
		@make = aMake
		@model = aModel
		@description = aDescription
		@colour = aColour
		@date = aManufactureDate
	  end

	  def text_format
		return "#{@vrm} -- #{@make} #{@model}  #{@date} (#{@description}, #{@colour})"
	  end
	end

	def save_to_file
	  @back_up = Hash.new
	  $all_vehicles.each do |a_vehicle |
	  #itterate through each record and create a hash with vrm as key
		@back_up[a_vehicle[1].vrm] = a_vehicle[1].make, a_vehicle[1].model, a_vehicle[1].colour, a_vehicle[1]. description, a_vehicle[1].date
	  end
	  File.write("vehicles.json",@back_up.to_json)
	  p 'Saved records to \'vehicles.json\''
	end

	def open_file
	  $all_vehicles = {}
	  #If file exists itterate through records and recreate objects
	  if File.file?("vehicles.json")
		File.open('vehicles.json') do |f|
		  @load_vehicles = JSON.parse(f.read)
		end
		@load_vehicles.each do |a_vehicle|
		  new_car = Car.new(a_vehicle[1][0], a_vehicle[1][1], a_vehicle[1][3], a_vehicle[1][2], a_vehicle[0], a_vehicle[1][4])
		  $all_vehicles[new_car.vrm] = new_car
		end
		count
	  else
		p 'Unable to find file, creating blank file'
		save_to_file
	  end
	end

	def count
	  p "You have #{$all_vehicles.count} records on file"
	end

	def gen_vrm(aManufactureDate)
	  suffix_age = { 1963 => "A",1964 => "B",1965 => "C",1966 => "D",1967 => "E",1968 => "F",1969 => "G",1970 => "H",1971 => "J",1972 => "K",
	1973 => "M",1974 => "N",1975 => "P",1976 => "R",1977 => "S",1978 => "T",1979 => "V",1980 => "W",1981 => "X",1982 => "Y"}
	  prefix_age = { 1983 => "A",1984 => "B",1985 => "C",1986 => "D",1987 => "E",1988 => "F",1989 => "G",1990 => "H",1991 => "J",1992 => "K",
	1993 => "L",1994 => "M",1995 => "N",1996 => "P",1997 => "R",1998 => "S",1999 => "T",2000 => "V",2001 => "W",}
	  if aManufactureDate.is_a?Integer
		 if (1983..2001).include?(aManufactureDate)    #PREFIX STYLE
		   prefix = prefix_age[aManufactureDate]
		   numbers =('0'..'9').to_a.shuffle.first(3).join
		   suffix =('A'..'Z').to_a.shuffle.first(3).join
		   @vrm = (prefix.to_s + numbers +suffix.to_s)
		 elsif (1963..1982).include?(aManufactureDate) # SUFFIX STYLE
		   prefix =('A'..'Z').to_a.shuffle.first(3).join
		   numbers =('0'..'9').to_a.shuffle.first(3).join
		   suffix = suffix_age[aManufactureDate]
		   @vrm = (prefix.to_s + numbers + suffix.to_s)
		 elsif (1903..1962).include?(aManufactureDate)   # HISTORIC
		   numbers =('0'..'9').to_a.shuffle.first(1).join
		   suffix =('A'..'Z').to_a.shuffle.first(3).join
			if (1903..1930).include?(aManufactureDate)
		   @vrm = (numbers + suffix.to_s)
			else
			  @vrm = (suffix.to_s + numbers)
			end
		 elsif aManufactureDate > 2001                 #CURRENT STYLE
		   prefix =('A'..'Z').to_a.shuffle.first(2).join
		   extract_year = aManufactureDate.to_s #Convert to string so we can grab the last 2 digits
		   extract_year.to_i
		   numbers = extract_year.chars.last(2).join
		   suffix =('A'..'Z').to_a.shuffle.first(3).join
		   @vrm = (prefix.to_s + numbers + suffix.to_s)
		 else                                          #Q PLATE
		   prefix = "Q"
		   numbers =('0'..'9').to_a.shuffle.first(3).join
		   suffix =('A'..'Z').to_a.shuffle.first(3).join
		   @vrm = (prefix.to_s + numbers + suffix.to_s)
		 end
	  end
	end

	def check_valid?(aVRM, aManufactureDate)
	#VRM should be unique, not be blank, not contain letter 'I' 
	#and only contain 'Q' as first character for vehicles with no manufacture date
	  bad_value = (aVRM.nil?) || (aVRM.include?("I")) || (aVRM[0] == ("0"))
	  bad_q = aVRM.include?("Q") && (aVRM[0] != 'Q' || (aVRM[0] == "Q" && (1903..2019).include?(aManufactureDate)))
	  already_exists = $all_vehicles[aVRM]
	  return !(bad_value || bad_q || already_exists)
	end

	def show_registrations
	  p 'Printing all registration marks on file:'
	  vrm_list =  $all_vehicles.keys
		p vrm_list.sort
	end

	def help
	  p ("new - adds new record")
	  p ("search - allows you to search by VRM, make, model and manufacture date")
	  p ("save - backs up all records to vehicles.json")
	  p ("vrm - displays all VRMs currently on file")
	  p ("count - displays number of current records")
	  p ("bulk - generates new records")
	end
			

	########################  Program starts here  ########################

	default_message = 'OPTIONS: new, search, save, bulk, vrm, offensive, count, help & exit'
	$all_vehicles = {}
	input = nil
	v = false
	ascii_intro
	open_file

	while input != ("exit")
	  p default_message
	  input = gets.downcase.chomp!
	  case input
	  when "new"
		add_new
	  when "help"
		help
	  when "search"
		search
	  when "count"
		count
	  when "bulk"
		bulk_add(v)
		count
	  when "bulk -v"
		v = true
		bulk_add(v)
		count
	  when "offensive"
		offensive
	  when "delete"
		delete
	  when "vrm"
		show_registrations
	  when "save"
		save_to_file
	  when "exit"
		exit
	  end
	end

