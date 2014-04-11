#!/user/bin/env ruby

$:.unshift File.expand_path('../../lib', __FILE__)
require 'optparse'
require 'checks'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: version_check.rb [OPTIONS]'
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

  opt.on('--key-index [INDEX]', 'index in input file for ssh key name') do |key_index|
    options[:key_index] = key_index
  end
  options[:key_index] = 1 unless options[:key_index]

  opt.on('--address-index [INDEX]', 'index in the input file for node address') do |index|
    options[:address_index] = index
  end
  options[:address_index] = 0 unless options[:address_index]
end

opt_parser.parse!

output = []
if options[:address]
  unless options[:key]
    raise Exception.new('If and address is specified, a key file must be as well')
  end

  output << [options[:address]] + check_openssl_version(options)

elsif options[:input]
  File.open(options[:input]).each do |node|
    fields = node.strip.split(',')
    options[:address] = fields[options[:address_index].to_i]
    options[:key] = fields[options[:key_index].to_i]

    begin
      output << (fields + check_openssl_version(options))
    rescue Exception => error
      puts error
      output << fields + ['CHECK FAILED', 'CHECK FAILED']
    end
  end
end

if options[:output]
  File.open(options[:output], 'w') do |csv|
    output.each do |line|
      csv.write(line.join(','))
      csv.write("\n")
    end
  end
else
  output.each{|line| puts line.join("\t")}
end
