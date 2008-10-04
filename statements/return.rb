#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: return.rb 78 2006-07-17 21:09:18Z bkerley $

# Return/give statements are used at the end of a function to actually return something.
# They are optional.
#
# Example:
# give motive, evidence
Note.v "$Id: return.rb 78 2006-07-17 21:09:18Z bkerley $"
class ReturnStatement < Statement
  #values to return
  @returns
  #load up values to return
  def initialize(line)
    rol = line.split(" ")[1..line.length]
    @returns = findrets(rol)
  end
  def run(argarr)
    if (@returns.class == Array)
      retarr = Array.new
      @returns.each do |r|
        retarr << argarr[r]
      end
      argarr[:__return] = retarr
    else
      argarr[:__return] = argarr[@returns]
    end
    #$stderr.puts "argarr at :__return is #{argarr[:__return]}"
  end
  def self.answer(line)
    return false unless line.split(" ")[0] == "give"
    return true
  end
  
  private
  #return cleaned up array of return values
  def findrets(rol)
    lastret = rol.length-1
    (0..lastret).each do |r|
      rol[r].gsub!(/\W/,'')
      rol[r] = rol[r].to_sym
    end
    return rol[0..lastret]
  end
end