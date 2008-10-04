#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-06-30.
# Copyright (c) 2006. All rights reserved.
#
# $Id: function.rb 80 2006-07-18 02:08:38Z bkerley $
Note.v "$Id: function.rb 80 2006-07-18 02:08:38Z bkerley $"
class Function
  attr_reader :functype, :funcname
    
  @@functions = nil
  
  def self.[](sym)
    @@functions[sym]
  end
  def self.functions
    @@functions
  end
  def self.functions=(val)
    @@functions=val
  end
  @funcname
  @functype
  @statements
  def initialize(funcname, funcarray)
    @funcname = funcname
    @functype = loadtype!
    @statements = funcarray
  end
  
  def statementize!
    newstatements = Array.new
    @statements.each do |s|
      newstatements << Statement.GetStatement(s)
    end
    @statements = newstatements
  end
  
  def run(argarr)
    argcounter = 0
    Note.p 1, "In #{funcname}"
    @statements.each do |s|
      s.run(argarr)
      if @functype == :attorney and s.respond_to? :argval
        argcounter += s.argval 
      end
    end
    Note.p 1, "Leaving #{funcname} with argcounter #{argcounter}"
    Note.p 1, "Final locals: "
    Note.p 1, YAML.dump(argarr)
    if argarr[:__return] != nil
      return argarr[:__return]
    else
      return nil
    end
  end
  
  @@functypes = {:GREEVEY => :detective, :CERRETA => :detective, :BRISCOE => :detective,
    :FONTANA => :detective, :GREEN => :detective,
    :LOGAN => :detective, :CURTIS => :detective, :FALCO => :detective,
    :CRAGEN => :captain, :"VAN BUREN" => :captain,
    :STONE => :attorney, :MCCOY => :attorney,
    :ROBINETTE => :attorney, :KINCAID => :attorney, :ROSS => :attorney,
    :CARMICHAEL => :attorney, :SOUTHERLYN => :attorney, :BORGIA => :attorney, 
    :SCHIFF => :attorney, :LEWIN => :attorney, :BRANCH => :attorney}
  
  def self.functype(funcname)
    return @@functypes[funcname]
  end
  
  def self.functypeadd(hash)
    Note.p 3, "Adding functypes:"
    Note.p 3, YAML.dump(hash)
    @@functypes.merge! hash
  end
  
  private
  def loadtype!
    # http://en.wikipedia.org/wiki/Law_%26_Order
    @functype = Function.functype(@funcname)
  end
end

Dir["spinoffs/*.rb"].each do |x|
  Note.p 3, "Adding spinoff #{x}"
  load x
end