#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-07-17.
# Copyright (c) 2006. All rights reserved.
#
# $Id: notice.rb 80 2006-07-18 02:08:38Z bkerley $
#
# for printing notices to console
class Note
  @@level = 0
  #-1 - always print
  # 0 - important
  # 1 - diagnostic
  # 2 - LAO debug
  # 3 - LAO serious debug
  
  @@versions = Array.new
  
  def self.level=(val)
    @@level = Integer(val)
    self.p 2, "Note set to level #{@@level}"
  end
  
  def self.p(lev, info)
    $stderr.puts info if (lev <= @@level)
  end
  
  def self.v(info)
    @@versions << info[1..-2]
  end
  
  def self.putver
    @@versions.each do |v|
      Note.p 2, v
    end
  end
end

if (ARGV.length > 1)
  Note.level = ARGV[0][-1].chr
end
Note.v "$Id: notice.rb 80 2006-07-18 02:08:38Z bkerley $"