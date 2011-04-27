#!/usr/bin/env jruby

require 'java'
require '/usr/share/java/mibble-mibs-2.9.2.jar'
require '/usr/share/java/mibble-parser-2.9.2.jar'

module MIBBLER

  include_package 'net.percederberg.mibble'
    
  module ASN1
    include_package 'net.percederberg.mibble.asn1'
  end

  
  module Value
    include_package 'net.percederberg.mibble.value'
  end
end

module JavaIO
  include_package "java.io"
end

module JavaArray
  include_package "java.util"
end

class Loaded_mibs
  attr_accessor :mibs

  def initialize(dir='/usr/share/mibs')
    @mibs = []
    @dir = dir
    dir = JavaIO::File.new(dir)
    @loader = MIBBLER::MibLoader.new
    queue = JavaArray::ArrayList.new
    MIBBLER::MibbleValidator.addMibs(dir, queue)
    queue.each do
      |mib|
      @mibs << @loader.load(mib)
    end
  end

  def parse_mib(file)
    mib = @loader.getMib(file)
    if mib == nil
      raise "No such mib loaded please load the mib!"
    end
    vpairs = extractoids(mib)
    return vpairs
  end

  def load_mib(mib)
    @mibs << @loader.load(mib)
  end
  
  def get_oid(*symbols)
      oids = []
      symbols.each do
        |symbol|
        @mibs.each do
          |m|
          if instance =  m.getSymbol(symbol)
            oid = extractoid(instance)
            oids << oid.to_s
            break
          end
        end
      end
      if oids.empty?
        raise "No OID's found!"
      elsif
        oids.length != symbols.length
        raise "Only one OID was found!"
      else
        return oids
      end
    end
    
  private
  def extractoids( mib )
    iter = mib.getAllSymbols.iterator
    hash = Hash.new
    while (iter.hasNext)
      symbol = iter.next
      value = extractoid(symbol)
      if value != nil
        name = symbol.getName
        hash[name] = value
      end
    end
    return hash
  end

  def extractoid(symbol)
    if  symbol.instance_of?(MIBBLER::MibValueSymbol)
      value = symbol.getValue
      if value.instance_of?(MIBBLER::Value::ObjectIdentifierValue)
        return value
      end
    else
      return nil
    end
  end
end