#!/usr/bin/env jruby

require 'rubygems'
require 'SNMP4JR'
require 'MIBBLER'

# This defaults to version 2c bulkwalk(most efficient method) unless you specify version1


mymibs = Loaded_mibs.new
oids = mymibs.get_oid('dot1dBasePort', 'sysDescr')

target = SNMPTarget.new(:host => '<switch-ip-address>', :community => 'public',
                        :version => SNMP4JR::MP::Version2c)
target.max_repetitions = 1
target.non_repeaters = 2

 target.get_bulk(oids).each do |vb|
   puts vb.to_s
end