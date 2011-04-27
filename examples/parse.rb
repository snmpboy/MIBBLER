#This script parses the 'WWW-MIB' Any loaded mib can be parsed.
# If MIBBLER returns and error stating MIB not found. Call the load_mib()
# method on the Loaded_mibs instance after you have placed that mib and
# its dependencies in your mib directory.

#!/usr/bin/env jruby

require 'rubygems'
require 'MIBBLER'

mymibs = Loaded_mibs.new('/usr/share/mibs')
value_pairs = mymibs.parse_mib('WWW-MIB')
value_pairs.each{|k,v| puts "#{k} => #{v}"}