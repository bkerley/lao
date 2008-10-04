#!/usr/bin/env ruby
#
# Created by Bryce Kerley on 2006-07-17.
# Copyright (c) 2006. All rights reserved.
#
# $Id: svu.rb 79 2006-07-18 00:23:50Z bkerley $
# 
# adds SVU-themed names
Note.v "$Id: svu.rb 79 2006-07-18 00:23:50Z bkerley $"
Function.functypeadd({
  :STABLER => :detective, :BENSON => :detective, :MUNCH => :detective,
  #omitting cragen, is already a captain in mainline LAO
  :JEFFRIES => :detective, :TUTUOLA => :detective,
  :CABOT => :attorney, :NOVAK => :attorney
})