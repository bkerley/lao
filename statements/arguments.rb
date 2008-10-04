#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: arguments.rb 78 2006-07-17 21:09:18Z bkerley $

# An Argument statement is something an attorney does during a trial.
# Trials only occur between opening and closing arguments, and as such evidence is only presented then
Note.v "$Id: arguments.rb 78 2006-07-17 21:09:18Z bkerley $"
class ArgumentsStatement < Statement
  @argtype
  #load up with the line just for now
  def initialize(line)
    @argtype = line.split(" ")[0].to_sym
  end
  def run(argarr)
    
  end
  def self.answer(line)
    return false unless line.split(" ")[1] == "arguments"
    return true
  end
end
