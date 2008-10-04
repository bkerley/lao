#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-29.
# Copyright (c) 2006. All rights reserved.
#
# $Id: lao.rb 81 2006-07-18 22:49:03Z bkerley $
#
# LAO interpreter main
require 'pathname'
require 'yaml'
require 'notice.rb'
require 'line.rb'
require 'function.rb'
require 'statements.rb'
Note.v "$Id: lao.rb 81 2006-07-18 22:49:03Z bkerley $"

unless ARGV.length >= 1
  puts "Usage: {$0} [-v?] progname"
  puts "where progname is a well-formed LAO program"
  puts "and [-v?] is an optional argument specifying verbosity (0 through 3)"
  puts "with 3 being obnoxious and 0 being only serious stuff"
  exit
end

infile = Pathname.new(ARGV[-1])

Note.putver

#preprocessor, function isolator
functions = Hash.new
curfunc = Array.new
curfuncname = String.new

infile.each_line do |l|
  l = Line.new(l)
  next if l.to_s.length == 0
  if l.isfunction
    if curfunc.length != 0
      functions[curfuncname.to_sym] = Function.new(curfuncname.to_sym,curfunc)
    end
    curfuncname = l.to_s
    curfunc = Array.new
  else
    curfunc << l
  end
end
if curfunc.length != 0
  functions[curfuncname.to_sym] = Function.new(curfuncname.to_sym,curfunc)
end

start = nil
functions.each do |n,f|
  f.statementize!
  if f.functype == :captain
    if start != nil
      Note.p -1, "what the shit, there's two captains: #{start.funcname} and #{f.funcname}"
      exit
    end
    start = f 
  end
end
Function.functions = functions
Note.p 3, YAML.dump(functions)
Note.p 3, "Starting execution"
start.run(Hash.new)
Note.p 3, "Execution finished"