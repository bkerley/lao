#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-07-18.
# Copyright (c) 2006. All rights reserved.
#
# $Id$
#
# have BRISCOE search corpses for foulplay [with magnifier]
# while (corpses)
#   corpses, foulplay = BRISCOE(corpses, magnifier)
# end
Note.v "$Id: call.rb 78 2006-07-17 21:09:18Z bkerley $"
class SearchStatement < Statement
  #symbol of function to call
  @function
  #argument to function as symbol
  @arg
  #return from function as symbol
  @return
  #load up function, args, returns
  def initialize(line)
    splits = line.split(" ")
    @function = splits[1].to_sym
    @arg = splits[3].to_sym
    @return = splits[5].to_sym
  end
  
  #call the referenced function with any arguments, take any returned values
  def run(argarr)
    callargs = Hash.new
    if @args.class == Array
      @args.each do |v|
        callargs[v] = argarr[v]
      end
    elsif @args.class == Symbol and argarr[@args].class == Hash
      argarr[@args].each do |k,v|
        callargs[k] = v
      end
    elsif @args.class == Symbol
      callargs[:__argument] = argarr[@args]
    end
    
    Function[@function].run(callargs)
    retarr = callargs[:__return]
    if ((!@returns) ^ (!retarr)) and (!@returns or !retarr)
      $stderr.puts "Return from #{@function} failed - expectation was nil xor returns was nil"
      $stderr.puts "Non-fatal for now, but shame on you"
      
      return
    elsif (!@returns) #and by extension retarr has to be nil
      return #this is ok
    elsif (@returns.class == Symbol and retarr.class != Array)
      argarr[@returns] = retarr
      return
    elsif (@returns.class == Array and retarr.class != Array)
      $stderr.puts "Return from #{@function} failed - expectation was an array but returns wasn't"
      $stderr.puts "Invalid statement:"
      YAML.dump(self, $stderr)
      $stderr.puts
      raise "Function return error - returning from #{@function} expecting returns #{@returns}"
    end
    #now we know @returns should be an array
    @returns.each do |r|
      argarr[r] = retarr.shift
    end
  end
  
  #function calls always start with a name that has a function type
  def self.answer(line)
    return false unless Function.functype(line.split(" ")[0].to_sym)
    return true
  end
  
  private

end

