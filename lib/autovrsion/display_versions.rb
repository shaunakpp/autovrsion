#!/usr/bin/env ruby
class DisplayLog
	def disp(path)
		begin
			@repo=Rugged::Repository.new(path)
			ref=@repo.head

			version_count = 0
			walker = Rugged::Walker.new(@repo)
			walker.push(ref.target)
			walker_counter = Rugged::Walker.new(@repo)
			walker_counter.push(ref.target)
			walker_counter.each {version_count += 1}

			walker_counter.reset

			walker.each { |c|
				STDOUT.puts "-----------------------------"+"version_number:".yellow + " #{version_count}".cyan + "---------------------------"
				file_count = 1
				STDOUT.puts c.message
				tree1 = c.tree
				tree1.each_blob 	{ |x| STDOUT.puts "(#{file_count})  #{x[:name]}"
				file_count+=1
			}
			version_count-=1 }
			walker.reset

		rescue Rugged::OSError
			STDOUT.puts "Path does not exist".red
		end
	end
end
