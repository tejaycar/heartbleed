if ARGV.include?('-h') || ARGV.include?('--help')
  abort "scan4ports.rb INPUTPATH OUTPUTPATH [DELIMITER] [IP INDEX]\n Where IP INDEX is the 0 based field index for the ip address in the INPUTFILE"
end

output = []

File.open(ARGV[0]).each do |line|
  results = ''

  fields = line.split(ARGV[2] || ',')
  output_line = fields

  index = ARGV[3] ? ARGV[3].to_i : 5
  ip = fields[index]
  p "Scanning #{ip}"
  scan = `sudo nmap -sS -oN - -p1-9999,10009-10010,10012,10024-10025,10082,10180,10215,10243,10566,10616-10617,10621,10626,10628-10629,10778,11110-11111,11967,12000,12174,12265,12345,13456,13722,13782-13783,14000,14238,14441-14442,15000,15002-15004,15660,15742,16000-16001,16012,16016,16018,16080,16113,16992-16993,17877,17988,18040,18101,18988,19101,19283,19315,19350,19780,19801,19842,20000,20005,20031,20221-20222,20828,21571,22939,23502,24444,24800,25734-25735,26214,27000,27352-27353,27355-27356,27715,28201,30000,30718,30951,31038,31337,32768-32785,33354,33899,34571-34573,35500,38292,40193,40911,41511,42510,44176,44442-44443,44501,45100,48080,49152-49161,49163,49165,49167,49175-49176,49400,49999-50003,50006,50300,50389,50500,50636,50800,51103,51493,52673,52822,52848,52869,54045,54328,55055-55056,55555,55600,56737-56738,57294,57797,58080,60020,60443,61532,61900,62078,63331,64623,64680,65000,65129,65389 #{ip}`
  scan.split(/\r?\n/).each do |line|
    if line.include?('open')
      results += ':' unless results == ''
      results += line[/\d+/]
      puts results
    end
  end
  puts "Need to check #{results}"
  output_line.insert(index + 1, results.to_s)
  output << output_line
end

File.open(ARGV[1], 'w') do |csv|
  output.each do |line|
    outline = ''
    line.each do |word|
      if word.include?(',')
        outline += "\"#{word.strip}\","
      else
        outline += "#{word.strip},"
      end
    end
    csv.write(outline[0..-2])
    csv.write("\n")
  end
end

puts output
