def check_for_heartbleed(options)
  results = {}
  options[:ports].split(':').each do |port|
    scan = `/tmp/bin/Heartbleed #{options[:address]}:#{port} 2>&1`
    if scan.include?('VULNERABLE')
      results[port] = 'VULNDERABLE'
    elsif scan.include?('ERROR')
      results[port] =  'ERROR'
    elsif scan.include?('SAFE')
      results[port] =  'SAFE'
    else
      results[port] =  'WHAT??'
      puts "Scan of #{options[:address]}:#{port} returned #{scan}"
    end
  end
  results
end

def get_ports(options)
  p "Checking ports on #{options[:address]}"
  scan = run_ssh_command(options, 'sudo netstat -tulpn')
  ports = []
  scan.split(/\r?\n/).each do |line|
    fields = line.split(/\s+/)
    next unless fields.first.start_with?('tcp') || fields[0].start_with?('udp')
    ports << fields[3].split(':').last
  end
  return ports.uniq
end

def check_openssl_version(options)
  scan = run_ssh_command(options, 'openssl version -v -b')
  scan = scan.split(/\r?\n/)
  version = scan.first.split(/\s+/)[1]
  build_date = scan.last.split("on: ").last
  return version, build_date
end

private

def run_ssh_command(options, command)
  keypath = ::File.join(options[:keys], options[:key])
  keypath = ::File.expand_path(keypath)
  raise Exception.new("Keyfile #{keypath} does not exist") unless ::File.exist?(keypath)

  output = `ssh -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' -i #{keypath} #{options[:username]}@#{options[:address]} '#{command}'`
end
