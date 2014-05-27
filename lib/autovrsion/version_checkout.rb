#!/usr/bin/env ruby
require 'git'
require 'rugged'
require 'colored'

class Checkout
	def chk(path)
		@repo = Rugged::Repository.new(path)
		begin
			puts "Enter Version number"
			g = Git.open(path)
			ver = STDIN.gets.to_i
			versh = Array.new()
			version_count = 0
			ref=@repo.head
			walker = Rugged::Walker.new(@repo)

			walker.push(ref.target)
			walker.each{ |x| version_count +=1}
			walker.reset
			
			walker.push(ref.target)
			walker.each { |w|
			#puts w.oid
			 versh[version_count-1] = w.oid 
			  version_count-=1 
			 }	
			walker.reset
			#g.commit
			#g.branch('update').checkout
			g.checkout(versh[ver])
			
			
			c = @repo.lookup(versh[ver])
		rescue Rugged::OSError
			puts "Path does not exist".red
		rescue TypeError
			puts "Enter Valid Version number".red
		else
			puts "Directory now at version no." + " #{ver}".yellow
			puts ""
			puts c.message 
			puts c.type
			tree1 = c.tree
			tree1.each_blob { |x| puts "#{x[:name]}".cyan }
		end	

	end
end
