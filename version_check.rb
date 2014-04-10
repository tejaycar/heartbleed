if ARGV.include?('-h') || ARGV.include?('--help')
  abort "version_check.rb INPUTPATH OUTPUTPATH PATH_TO_SSH_KEYS SSH_USERNAME [DELIMITER] [IP_INDEX] [KEY_INDEX]\n Where IP_INDEX and KEY_INDEX are the 0 based field index for the ip address and ssh key name in the INPUTFILE"
end

output = []

File.open(ARGV[0]).each do |line|
  results = ''

  fields = line.split(ARGV[4] || ',')
  output_line = fields

  ip_index = ARGV[5] ? ARGV[5].to_i : 5
  key_index = ARGV[6] ? ARGV[6].to_i : 6
  ip = fields[index]
  p "Checking version on #{ip}"
  scan = `ssh -i #{ARGV[3]}/#{fields[key_index]} #{ARGV[3]}@#{fields[ip_index]} 'openssl version -a'`
  version = scan.scan(/OpenSSL.*\d+\n/)
  build_date = scan.scan(/built on.*\n/)
  puts "Version: #{version} #{build_date}"
  output_line.insert(index + 1, version)
  output_line.insert(index + 2, build_date)
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
