#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-07-18.
# Copyright (c) 2006. All rights reserved.
#
# $Id: interrogate.rb 81 2006-07-18 22:49:03Z bkerley $
#
# takes string input

Note.v "$Id: interrogate.rb 81 2006-07-18 22:49:03Z bkerley $"
class CountStatement < Statement
  @dest
  #load up with the line just for now
  def initialize(line)
    splits = line.split(' ')
    @dest = splits[1].to_sym
  end
  
  #assign the argument into the variable
  def run(argarr)
    Note.p 3, "Interrogating into #{@dest}"
    Note.p 1, "Input string:"
    argarr[@dest] = $stdin.gets.chomp
    Note.p 1, "Read \"#{argarr[@dest]}\" into #{@dest}"
  end
  
  #assignments are always "variable is value"
  def self.answer(line)
    return false unless line.split(" ")[0]=="interrogate"
    return true
  end
  
  private
  
end
