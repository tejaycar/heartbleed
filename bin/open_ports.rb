$LOAD_PATH << File.dirname(File.dirname(__FILE__))
require 'optparse'
require 'lib/checks'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: open_ports.rb [OPTIONS]'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-k', '--keys-path [PATH]', 'path to ssh keys') do |keypath|
    options[:keys] = keypath
  end
  options[:keys] = '~/.ec2' if options[:keys].nil?

  opt.on('-u', '--username [USERNAME]', 'username for ssh') do |username|
    options[:username] = username
  end
  options[:username] = 'ubuntu' if options[:username].nil?

  opt.on('-f', '--file [FILE]', 'A csv file with IPADDRESS and KEYNAME for one or more servers to check') do |input|
    options[:input] = input
  end

  opt.on('-o', '--output [OUTPUT]', 'Path to output results to.  If left out, output will go to stdout') do |output|
    options[:output] = output
  end

  opt.on('-a', '--address [ADDRESS]', 'Address of node to test') do |address|
    options[:address] = address
  end

  opt.on('-i', '--key-name [KEYNAME]', 'Name of ssh key') do |key|
    options[:key] = key
  end
end

opt_parser.parse!

output = []

if options[:address]
  unless options[:key]
    raise Exception.new('If and address is specified, a key file must be as well')
  end

  ports = get_ports options
  ports = ports.join(':')
  output << [options[:address], options[:key], ports]
end

if options[:input]
  File.open(options[:input]).each do |node|
    options[:address], options[:key] = node.split(',')
    ports = get_ports options
    ports = ports.join(':')
    output << [options[:address], options[:key], ports]
  end
end

if options[:output]
  File.open(options[:output], 'w') do |csv|
    output.each do |line|
      outline = ''
      line.each do |word|
        if word && word.include?(',')
          outline += "\"#{word.strip}\","
        else
          outline += "#{word ? word.strip : ''},"
        end
      end
      csv.write(outline[0..-2])
      csv.write("\n")
    end
  end
else
  output.each{|line| puts line.join("\t")}
end
