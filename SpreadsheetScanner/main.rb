require 'roo'

$end_points = []
$loaded_xlsx = []

def load(filename)
  xlsx = Roo::Spreadsheet.open(filename)
  xlsx.each_with_pagename do |name, sheets|
    sheets.each_row_streaming do |row|
      row.each do |cell|
        if cell.class == (Roo::Excelx::Cell::String) && cell.value.include?("http://localhost")
            $end_points << cell.value
        end
      end
    end
  end
end

def save
  if $end_points != [] then
    $end_points.uniq!
    $end_points.sort!
    File.open("results.txt", "w") { |file| file.puts $end_points}
    p "Saving to results.txt"
  else
    p 'Nothing found!'
  end
end

def check_for_new
  directory = Dir['**/*'].reject {|fn| File.directory?(fn) } #List all files
  directory.each do |name|
    if name.include?("~")
      p "Can't parse #{name}, sorry about that"
     else
    if name.include?(".xlsx")  #if it's a xlsx
      $loaded_xlsx << name #record file name for future checks
      p "Scanning #{name}..."
      load(name) #load it
    end
      end
  end
end

######## Program starts here ########

print "Looking for .xlsx files! \r"
check_for_new
save


