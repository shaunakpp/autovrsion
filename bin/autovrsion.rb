#!/usr/bin/env ruby

require 'listen'
require 'rugged'
require 'git'

case ARGV[0]
	when "options"
		puts "\tdisplay"
		puts "\tstart"
		puts "\tstop"
		puts "\tcheck"
		puts "\tcreate" 
		puts "\treset"
		puts "\trewind"
	when "display"
		require 'autovrsion/lib/display_versions.rb'
		d= DisplayLog.new
		d.disp(ARGV[1])
	when "start"
		require 'autovrsion/lib/filelistener.rb'
		f = FileListen.new
		f.lis(ARGV[1])
	when "check"
		require 'autovrsion/lib/version_checkout.rb'
		v = Checkout.new
		v.chk(ARGV[1])
	when "create"
		require 'autovrsion/lib/create_repository.rb'
		c  = CreateRepo.new
		c.create(ARGV[1])
	when "reset"
		require 'autovrsion/lib/reset.rb'
		r = Reset.new
		r.reset(ARGV[1])
	when "rewind"
		require 'autovrsion/lib/rewind.rb'
		rw = Rewind.new
		rw.rewindto(ARGV[1])
	end	
