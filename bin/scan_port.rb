$LOAD_PATH << File.dirname(File.dirname(__FILE__))
require 'optparse'
require 'lib/checks'
require 'pp'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: scan_port.rb [OPTIONS]'
  opt.separator ''
  opt.separator 'Options'

  opt.on('-f', '--file [FILE]', 'A csv file with IPADDRESS and KEYNAME for one or more servers to check') do |input|
    options[:input] = input
  end

  opt.on('-o', '--output [OUTPUT]', 'Path to output results to.  If left out, output will go to stdout') do |output|
    options[:output] = output
  end

  opt.on('-a', '--address [ADDRESS]', 'Address of node to test') do |address|
    options[:address] = address
  end

  opt.on('-p', '--port [PORT[:PORT]..]', 'port to check') do |port|
    options[:ports] = port
  end
  options[:ports] = '443' if options[:ports].nil?
end

opt_parser.parse!

output = []

if options[:address]
  output << [options[:address], check_for_heartbleed(options)]
end

if options[:input]
  File.open(options[:input]).each do |node|
    options[:address], options[:ports] = node.split(',')
    output << [options[:address], check_for_heartbleed(options)]
  end
end

if options[:output]
  File.open(options[:output], 'w') do |csv|
    output.each do |line|
      csv.write(line.join(','))
      csv.write("\n")
    end
  end
end

output.each{|node| puts node.join("\t")}
