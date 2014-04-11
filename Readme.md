Contains 4 utilities for checking the heartbleed vulnerability, and a Vagrantfile for building the machine that can run them.

Preparation
---------------
These tools assume you have ssh keys with .pem extensions in your ~/.ec2 directory.  If you
have placed them in another directory, then you will need to update the vagrantfile to sync
the appropriate directory.  NOTE, input flags and files expect the name of the key, and will append the .pem extension for you.

Run `vagrant up` to generate a virtual machine with the Heartbleed vulnerability checker installed.


Usage
-------------
All four can accept a single node via flags, or a csv file containing a list of machines to check.
When providing a csv file, it is assumed that the file contains two columns ADDRESS, KEYNAME (or ADDRESS, PORTS for scan_port.rb).
If this is not the case, you can override the ADDRESS-INDEX, KEY-INDEX, and PORT-INDEX using flags to indicate other columns.

##Output
Output is controlled by the -o flag.  It's absence will result in output printed to stdout.
All output is csv formatted.  When an input file is provided (via -f), the output will be a
line for line concatenation of the input line and the results.  When input is provided only
via the command line flags, then output will contain the address and output only.

open_ports.rb
-----------
This is the least useful, but will simply run an ssh command to grab a list of all listening ports on each node.
The output field contains a colon (:) delimited set of ports

version_check.rb
----------------
This will ssh to the servers and retrive the current version of openssl.  Very useful for validation.

scan_port.rb
----------------
If you know the ports you are concerned about, you can run `scan_port.rb` to check them.  This will
run the vulnerability checker on all nodes in your input file and report out on them.  For more
than one port per node, provide a colon (:) separated list of ports.

full_scanner.rb
----------------
This one will combine the talents of `open_ports` and `scan_port` and is the best one to use in most cases.
It will take a csv of addresses and keynames, get a list of open ports on each address, scan
all of those ports, and then report back on findings.