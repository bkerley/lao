#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: present.rb 78 2006-07-17 21:09:18Z bkerley $
Note.v "$Id: present.rb 78 2006-07-17 21:09:18Z bkerley $"
class PresentStatement < Statement
  @variable
  @argval = 0
  attr_reader :argval
  
  #load up with the line just for now
  def initialize(line)
    @variable = line.split(" ")[1].to_sym
  end
  def run(argarr)
    #$stderr.puts "at #{@variable} in argarr is #{argarr[@variable]}"
    if argarr[@variable].is_a? Numeric
      @argval = argarr[@variable]
    else
      @argval = 0
      $stdout.puts argarr[@variable]
    end
  end
  def self.answer(line)
    return false unless line.split(" ")[0] == "present"
    return true
  end
end