if ARGV.include?('-h') || ARGV.include?('--help')
  abort "detect_heartbleed.rb INPUTPATH OUTPUTPATH [DELIMITER] [IP INDEX]\n Where IP INDEX is the 0 based field index for the ip address in the INPUTFILE"
end

output = []

File.open(ARGV[0]).each do |line|
  results = ''

  fields = line.split(ARGV[2] || ',')
  output_line = fields

  index = ARGV[3] ? ARGV[3].to_i : 5
  ip = fields[index]
  p "Checking #{ip}"
  index = ARGV[4] ? ARGV[4].to_i : 6
  fields[index].split(':').each do |port|
    scan = `/tmp/bin/Heartbleed #{ip}:#{port} 2>&1`
    if scan.include?('VULNERABLE')
      results += "#{port} - FAILED:"
    elsif scan.include?('ERROR')
      results += "#{port} - ERROR:"
    elsif scan.include?('SAFE')
      results += "#{port} - SAFE:"
    else
      results += "#{port} - WHAT???:"
    end
  end
  puts results
  output_line[index] = results
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
