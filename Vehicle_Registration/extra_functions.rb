	
def ascii_intro
  if File.file?("intro.txt") #print from a file so ruby can't parse through and ruin it
	  File.open('intro.txt').each do |line|
	  print line.red
		end
	else
		p 'Ruby SOM Demo - No Ascii art for you'
  end
end

def add_new
  p "Manufacture Date?"
  aManufactureDate = gets.to_i
  new_vrm = ''
  30.times do
	new_vrm = gen_vrm(aManufactureDate)
	break if check_valid?(new_vrm, aManufactureDate)
	new_vrm = ''
  end
  raise 'We were unable to generate a valid VRN' if new_vrm.empty?
  p "New VRM generated: #{new_vrm}"
  p 'Make?'
  make = gets.chomp!
  p 'Model?'
  model = gets.chomp!
  p 'Description?'
  description = gets.chomp!
  p 'Colour?'
  colour = gets.chomp!
  # Make the car object
  new_car = Car.new(make, model, description, colour, new_vrm, aManufactureDate)
  # Add the car to our big list
  $all_vehicles[new_vrm] = new_car
  p "We added #{new_car.text_format} to the list"
end

def bulk_add(v)
  make_model = {
  "audi" =>%w[A1 A3 A4 A5 A6 A7 A8 Allroad Quattro Cabriolet E-tron Fox Q2 Q3 Q5 Q7 Q8 R8 RS Q3 RS3 RS4 RS5 RS6 RS7 S1 S2 S3 S4 S5 S6 S7 S8 SQ5 SQ7 TT V8_Quattro],
  "aston_martin" =>%w[DB11 DB4 DB5 DB6 DB7 DB9 DBS Lagonda_Rapide V12_Vanquish V8_Vanquish Vantage Virage Volante],
  "bmw" =>%w[1_Series 2_Series 3_Series 4_Series 5_Series 6_Series 7_Series i3 i4 i8 M2 M3 M4 M5 M6 X1 X2 X3 X4 X5 X6 X7 Z3 Z4],
  "citroen" =>%w[Ax Berlingo C2 C3 C4 C4 Aircross C4_Cactus C4_Picasso C5 C6 CX_D Dispatch DS DS3 DS4 DS5 C4_Picasso Xantia Xsara],
  "daewoo" =>%w[Cielo Espero Kalos Korando Lacetti Lanos Leganza Matiz Musso Nubira Tacuma],
  "fiat" =>%w[Argenta Croma Doblo DUCATO Freemont Panda PANORAMA Punto Regata Ritmo Scudo Superbrava],
  "jauguar" =>%w[240 340 420 E_Type Majestic S-TYPE Sovereign V12_Vanden X-TYPE XE XF XJ XJ12 XJ6 XJ8 XJR XJS XJSC XK XK8 XKR],
  "land_rover" =>%w[Defender Discovery Discovery_3 Discovery_4 Discovery_Sport Freelander Freelander_2 Range_Rover Range_Rover_Evoque Range_Rover_Sport],
  "nissan" =>%w[300ZX 350Z 370Z Almera Altima Bluebird Cabstar Cedric Cube Dualis Elgrand Gazelle GT-R Homer Juke Leaf Maxima Micra Murano Navara Nomad NX-R Pathfinder Patrol Pintara Pulsar Qashqai Serena Skyline Stanza Sunny TERRANO_II Ute X-Trail],
  "mercedes" =>%w[A150 C220 C230 C280 C320 C350 C43_AMG E63 S65 SLS Sprinter Valente Viano Vito],
  "mitsubishi" =>%w[3000 Challenger Colt Cordia D50 Eclipse Cross Express Galant Grandis L200 L300 Lancer Magna Mirage Nimbus Outlander Pajero Pajero_Sport Sigma Starion Triton Verada],
  "renault" =>%w[Alaskan Captur Caravelle Clio Clio_RS Dauphine Floride Fluence Fuego Grand_Scenic Kadjar Kangoo Koleos Laguna Latitude Master Megane RS R25 R4 R8 Scenic Trafic Virage Zoe],
  "vauxhall" =>%w[Astra Corsa Insignia Zafira],
  "vw" =>%w[Amarok Arteon Beetle Bora Caddy Caravelle Citivan CRAFTER Eos Golf Jetta Karmann Kombi Multivan Passat Polo Scirocco T-CROSS Tiguan Touareg Transporter Up! Vento]
  }
  description = %w[fast slow low broken stolen slammed undercover untaxed exported cloned]
  colour = %w[blue red green silver grey white black]
  p 'How many records are we generating?'
  count = gets.chomp.to_i
  total = count + $all_vehicles.count
  count.times do |index|
	@aManufactureDate = rand(1940..2019).to_i # in theory no Q plates
	#Give it more tries if generating >1,000,000
	250.times do
	  @new_vrm = gen_vrm(@aManufactureDate)
	  break if check_valid?(@new_vrm, @aManufactureDate)
	  @new_vrm = ''
	end
	raise 'We were unable to generate a valid VRN' if @new_vrm.empty?
	  make = make_model.keys.sample
	  model = make_model[make].sample
	  new_car = Car.new(make, model, description.sample, colour.sample, @new_vrm, @aManufactureDate)
	  $all_vehicles[@new_vrm] = new_car
	  p "We added #{new_car.text_format} to the list" if v
	  print "Generating #{$all_vehicles.count} / #{total} \r" unless v
  end
end

def search
  p 'Search by: [1]VRM, [2]Manufacture, [3]Model, [4]Year'
  match_field = gets.to_i
  p 'Enter the exact value to match against'
  match_value = gets.chomp!
   found_vehicle = nil
  found_list = []
  #Search stops when it finds VRM, but continues for everything else to generate a list
  $all_vehicles.each_value do |a_vehicle|
	case match_field
	when 1
	  found_vehicle = a_vehicle if a_vehicle.vrm == match_value
	when 2
	  found_list << a_vehicle if a_vehicle.make == match_value
	when 3
	  found_list << a_vehicle if a_vehicle.model == match_value
	when 4
	  found_list << a_vehicle if a_vehicle.date == match_value.to_i
	else
	  p "There is no option #{match_field}"
	  break
	end
	break if found_vehicle
  end

  if found_vehicle
	 text =  "Found a vehicle : #{found_vehicle}"
	 p found_vehicle.text_format
  elsif found_list != []
	p 'Found these vehicles'
	found_list.each do |vehicles|
	  p vehicles.text_format
	end
  else
	p "Unable to find a vehicle for #{match_value}"
  end
end

def delete
	p 'You can delete by VRM only'
	p 'Please enter registration of the vehcile to delete'
	input = gets.chomp!
	p "Delete record #{$all_vehicles[input].text_format}" unless ($all_vehicles[input] == nil)
	p 'Are you sure? [Y]es or [N]o'
	confirm = gets.chomp!
	case confirm.upcase!
	when "N"
		p 'No records have been deleted'
	when "Y"
		p 'deleting'
		p $all_vehicles[input].text_format
		$all_vehicles.delete(input)
		save_to_file
		count
	end     		         		
end

def offensive
	$bad_vrms = Hash.new
	offensive_list = []
	start_time = Time.now
	if File.file?("simple_search.txt")
		File.open('simple_search.txt').each do |line|
			offensive_list << line		
		end
		basic_check(offensive_list)  # checks for obvious violations eg: CNT, FCK, TWT
	else
	p 'Can\'t open file'
	end
	if File.file?("full_search.txt")
		File.open('full_search.txt').each do |line|
			offensive_list << line
		end
		p "Comparing #{$all_vehicles.count} records against #{offensive_list.count} banned combinations averaging 750 per second"
		timer = ($all_vehicles.count / 750) + 1 #obviously the more vrms the less accurate this is
		p "This will take a approximately #{timer} seconds" unless timer > 60
		p "This will take a approximately #{timer / 60} minute(s)" unless timer <= 60
		full_search(offensive_list)   # checks for wildcard expressions
	else
		p 'Can\'t open file'
	end
	end_time = Time.now
	time_taken = end_time - start_time
	count = 0
	$bad_vrms.each_value do |vrm|
		count = count + vrm.count
	end
	
	puts "*                                         ---                                         *"
	puts "REPORT:"
	puts "Found #{count} illegal registrations in #{time_taken} seconds"
	
	$bad_vrms.each_key do |example|
		if $bad_vrms[example].count < 10
			vrm = $bad_vrms[example].to_s
			vrm.tr!("\"", "")
			p "Combination #{example} matched #{vrm} "
		else
			p "Combination #{example} matched #{$bad_vrms[example].count} registrations"
		end				
	end
end

def basic_check(offensive_list)
	vrm_list = $all_vehicles.keys
	vrm_list = vrm_list.sort
	vrm_list.each do |vrm|
		offensive_list.each do |bad_combo|   
			bad_combo.strip!
			if vrm.include?(bad_combo)
				offensive_found(vrm, bad_combo)
			end
		end
	end
end

def full_search(offensive_list)
	vrm_list = $all_vehicles.keys.sort
	offensive_examples = offensive_list.map(&:strip)
	offensive_examples.each do |offensive_example|	
		vrm_list.grep(/^#{offensive_example}$/).each do |offensive_vrm| 
			print "Recently matched: #{offensive_example} with #{offensive_vrm} \r"
			offensive_found(offensive_vrm, offensive_example)
		end
	end
end

def offensive_found(offensive_vrm, offensive_example)
	if $bad_vrms[offensive_example] # if we already have a record
		prev_matched = $bad_vrms[offensive_example] #just add to the array
		prev_matched << offensive_vrm
		$bad_vrms.store(offensive_example, prev_matched)
	else
		new_match = [offensive_vrm]        # or create a new hash key 
		$bad_vrms.store(offensive_example, new_match)
	end
end
