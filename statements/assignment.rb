#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: assignment.rb 81 2006-07-18 22:49:03Z bkerley $
Note.v "$Id: assignment.rb 81 2006-07-18 22:49:03Z bkerley $"
class AssignmentStatement < Statement
  @dest
  @srcs
  #load up with the line just for now
  def initialize(line)
    splits = line.split(' ')
    @dest = splits[0].to_sym
    @srcs = getsrcs(splits[2..splits.length].join(' '))
  end
  
  #assign the argument into the variable
  def run(argarr)
    #$stderr.puts "Assigning #{@srcs.class} to #{@dest}"
    
    if @srcs.class == Array
      newsrc = Hash.new
      @srcs.each do |v|
        if v.class == Symbol
          newsrc[v] = argarr[v]
        else
          newsrc[v.to_sym] = v #this is kind of useless
        end
      end
      argarr[@dest] = newsrc
    elsif @srcs.class == Symbol
      argarr[@dest] = argarr[@srcs]
    else
      argarr[@dest] = @srcs
    end
    Note.p 3, "argarr at #{@dest} is #{argarr[@dest]}"
  end
  
  #assignments are always "variable is value"
  def self.answer(line)
    return false unless line.split(" ")[1]=="is"
    return true
  end
  
  private
  
  def getsrcs(rol)
    splits = rol.split(',')
    srcs = Array.new
    
    splits.each do |s|
      s.gsub!(/^\s*/,'')
      s.gsub!(/\s*$/,'')
      
      if (s.match(/^\"(.*)\"$/))
        srcs << $1
      elsif (checkint(s))
        srcs << Integer(s)
      elsif (checkfloat(s))
        srcs << Float(s)
      else
        srcs << s.to_sym
      end
    end
    return srcs[0] if srcs.length == 1
    return srcs
  end
  
  def checkint(str)
    begin
      x = Integer(str)
    rescue ArgumentError => e
      return false
    end
    return true
  end
  
  def checkfloat(str)
    begin
      x = Float(str)
    rescue ArgumentError => e
      return false
    end
    return true
  end
end
