#!/usr/bin/env ruby
class Rewind
	def rewind path
		@repo = Rugged::Repository.new(path)
		ref = @repo.head
		version_count = 0
		walker_counter = Rugged::Walker.new(@repo)
		walker_counter.push(ref.target)
		walker_counter.each {version_count += 1}
		STDOUT.puts "Warning ! You will lose current data if u rewind to previous version".red
		STDOUT.puts "Do you wish to continue ?(1/0)"
		ch = STDIN.gets
		ch.chomp
		STDOUT.puts ch
		if ch.to_i == 1
			STDOUT.puts "Enter Version number"
			version_no = STDIN.gets.to_i

			#begin
			@repo.index.add_all
			@repo.index.write
			v = version_count - version_no
			@repo.reset("HEAD~#{v}", :hard)
			STDOUT.puts "Rewind Successful to version number".green + " #{version_no}".yellow
			#rescue Rugged::InvalidError
			#		STDOUT.puts "Enter Valid Version no"
			#	end
		else
			STDOUT.puts "exiting..."
			abort
		end
	end
end
