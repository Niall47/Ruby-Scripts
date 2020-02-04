require 'json'
$recent_lap = Hash.new #lulzsec
$new_lap = Hash.new
$loaded_json = []

def ascii_intro
  if File.file?("intro.txt") #print from a file so ruby can't parse through and ruin it
    File.open('intro.txt').each do |line|
      print line
    end
    print "\n "
    p "Get in loser, we're going racing"
  else
    p 'Even our Ascii art failed to load'
  end
end

def load(filename)
  if File.file?(filename)
    p "Opening #{filename}"
    File.open(filename) do |f|
      $recent_lap = JSON.parse(f.read)
    end
    $recent_lap.each_with_index do |lap_data|
    datalog(lap_data)
    end
  else
    p 'Unable to find file, creating blank file'
    save(filename)
  end
end

def save(filename)
  @back_up = Hash.new
  file = filename + ".json"
  $new_lap.each do |lap_stats|
  #DATA GOES HERE
  end
  File.write(file,@back_up.to_json)
  p 'Saved records to home directory'
end

def datalog(lap_data)
    p lap_data
end

def check_for_new
  directory = Dir['**/*'].reject {|fn| File.directory?(fn) } #List all files
  directory.each do |name|
    unless $loaded_json.include?(name)
      if name.include?(".json")  #if it's a json
        $loaded_json << name #record file name for future checks
        load(name) #load it
      end
    end
    end
end

######## Program starts here ########

ascii_intro

loop do
  check_for_new
  print "Feed me data! \r"
end



