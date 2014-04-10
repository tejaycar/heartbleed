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
  scan = `sudo nmap -sS -p- #{ip}`
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
