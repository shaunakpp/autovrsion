#!/usr/bin/env ruby
require 'rugged'
require 'listen'
require 'colored'

class FileListen
	def lis(path,option)
			begin
			puts "Listening to changes.enter "+"stop ".red+"or"+" 1 ".red+"to stop listening to changes"
			repo=Rugged::Repository.new(path)
			listener = Listen.to(path,only: [/^^[\/[a-zA-Z]*]*["Untitled Document"]/,/^[\/[a-zA-Z]*]*[".git"]/]) do |modified,added,removed|

	  			index = repo.index
				user =  {
				 			name: repo.config['user.name'],
	             			email: repo.config['user.email'],
	             			time: Time.now
	         			}

					commit_options = {}
					commit_options[:author] = user
					commit_options[:committer] = user
					commit_options[:parents] = repo.empty? ? [] : [ repo.head.target ].compact
					commit_options[:update_ref] = 'HEAD'

				if modified.empty? == false
					index.reload
					modified.each do |x|
						x.gsub!(/[a-zA-Z]*[\/]/,"")
						puts x
						index.add("#{x}")
						end

					commit_options[:tree] = index.write_tree(repo)
					m = modified
					index.write
					m.each do |x|
						x.gsub!(/(\[)(\/[a-zA-Z]*)*(\/)/,"")
						x.gsub!(/\]/,"")
						puts x
					end
					commit_options[:message] ||= "#{m} modified at "+"#{Time.now}"

					Rugged::Commit.create(repo,commit_options)
					puts "File Modified".yellow
				end

				if added.empty? == false
					index.reload
					added.each do |x|
						x.gsub!(/[a-zA-Z]*[\/]/,"")
						index.add("#{x}")
						if x == "Untitled Document"
							index.remove("Untitled Document")
						end
					end

					a = added
					commit_options[:tree] = index.write_tree repo
					a.each do |x|
						x.gsub!(/(\[)(\/[a-zA-Z]*)*(\/)/,"")
						x.gsub!(/\]/,"")
						puts x
					end

					index.write
					commit_options[:message] ||= " #{a} added at "+"#{Time.now}"
					if a[0] != "Untitled Document"
					Rugged::Commit.create(repo,commit_options)
					puts "File Added".green
					end
				end

				if removed.empty? == false

					index.reload
					r = removed
					index.add_all
					commit_options[:tree] = index.write_tree(repo)
					r.each do |x|
						x.gsub!(/(\[)(\/[a-zA-Z]*)*(\/)/,"")
						x.gsub!(/\]/,"")
					end
					index.write
					commit_options[:message] ||= "#{r} removed at "+"#{Time.now}"
					if r[0] != "Untitled Document"
						Rugged::Commit.create(repo,commit_options)
						puts "File Removed".red
					end
				end
			end

			listener.start
			stop  = STDIN.gets
			if stop == "stop"
				puts "Listener stopped"
				listener.stop
			end

			if stop.to_i == 1
					listener.stop
					abort"Listener stopped"
			end
	rescue Errno::ENOENT
		puts "Error !Path does not exist".red
	end
	end

end
