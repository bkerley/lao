#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-29.
# Copyright (c) 2006. All rights reserved.
#
# $Id: line.rb 78 2006-07-17 21:09:18Z bkerley $
Note.v "$Id: line.rb 78 2006-07-17 21:09:18Z bkerley $"
class Line < String
  @isfunction = false
  attr_reader :isfunction
  
  def initialize(contents)
    super(contents)
    stripcomment!
    stripleadwhite!
    striptailwhite!
    checkfunction
  end
  
  private
  def checkfunction
    return unless isfunctionstart?
    @isfunction = true
    stripfunctionid!
  end
  
  def isfunctionstart?
    return true if self.match(/^-DOINK DOINK-/)
    return false
  end
  
  def stripfunctionid!
    self.gsub!(/^-DOINK DOINK-\s*/,'')
  end
  
  def stripcomment!
    self.gsub!(/#.*/,'')
  end
  
  def stripleadwhite!
    self.gsub!(/^\s*/,'')
  end
  
  def striptailwhite!
    self.gsub!(/\s*$/,'')
  end
end