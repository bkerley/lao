#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: statements.rb 78 2006-07-17 21:09:18Z bkerley $
Note.v "$Id: statements.rb 78 2006-07-17 21:09:18Z bkerley $"
class Statement
  @@statementtypes = Array.new
  
  #presents a line to each registered kind of statement to see who wants it
  def self.GetStatement(line)
    type = nil
    @@statementtypes.each do |t|
      next unless t.answer(line)
      type = t
      break
    end
    throw "Invalid statement #{line}" if type == nil
    type.new(line)
  end
  
  #implements plug-in nature of statements
  def self.inherited(stmttype)
    @@statementtypes << stmttype
  end
  
  #cannot generically answer - might try throwing some time
  def self.answer
    false
  end
  
  #fail because this is just generic
  def initialize(line)
    throw "Can't initialize this you dork"
  end
  
  #also fail
  def run(argarr)
    throw "Can't run this jerk"
  end
end

# Default/sample statement - does nothing
# 
# Fun fact: this was the first statement implemented and at one point it answered everything
class NopStatement < Statement
  def initialize(line)
    #nop
  end
  def run(argarr)
    #nop
  end
  def self.answer(line)
    return true if line.match(/^desk/)
  end
end

Dir["statements/*.rb"].each do |x|
  load x
end