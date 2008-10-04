#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: call.rb 78 2006-07-17 21:09:18Z bkerley $

# A call statement is when a function is given arguments and sometimes told to return a value
#
# Example:
# BRISCOE here is case file; give me motive, evidence
Note.v "$Id: call.rb 78 2006-07-17 21:09:18Z bkerley $"
class CallStatement < Statement
  #symbol of function to call
  @function
  #array of arguments to function as symbols
  @args
  #array of returns from function as symbols
  @returns
  #load up function, args, returns
  def initialize(line)
    splits = line.split(" ")
    @function = splits[0].to_sym
    words = splits.length
    rol = splits[1..(words-1)]
    @args = findargs(rol)
    @returns = findrets(rol)
  end
  
  #call the referenced function with any arguments, take any returned values
  def run(argarr)
    #$stderr.puts "Calling function with arguments #{@args.class}"
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
  #return cleaned up array of arguments
  def findrets(rol)
    give = rol.index("give")
    here = rol.index("here")
    return nil unless give
    
    if (here == nil or here < give)
      lastarg = rol.length() -1
    elsif (here > give)
      lastarg = here -1
    end
    (give+2..lastarg).each do |a|
      rol[a].gsub!(/\W/,'')
      rol[a] = rol[a].to_sym
    end
    return nil if rol[give+2..lastarg].length == 0
    return rol[give+2..lastarg][0] if rol[give+2..lastarg].length == 1
    return rol[give+2..lastarg]
  end
  
  #return cleaned up array of return values
  def findargs(rol)
    give = rol.index("give")
    here = rol.index("here")
    return nil unless here
    
    if (give == nil or give < here)
      lastret = rol.length() -1
    elsif (give > here)
      lastret = give -1
    end
    (here+2..lastret).each do |r|
      rol[r].gsub!(/\W/,'')
      rol[r] = rol[r].to_sym
    end
    return nil if rol[here+2..lastret].length == 0
    return rol[here+2..lastret][0] if rol[here+2..lastret].length == 1
    return rol[here+2..lastret]
  end
end
