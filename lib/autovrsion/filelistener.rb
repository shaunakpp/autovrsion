#!/usr/bin/env ruby
require 'rugged'
require 'listen'
require 'colored'
require 'daemons'

class FileListen
	def lis(path,option)		
		daemon = Daemons.call() do

		repo=Rugged::Repository.new(path)
		#callback = Proc.new do |modified,added,removed|		
				listener = Listen.to(path) do |modified,added,removed|	
			index = repo.index
			 user =  {
			 			name: repo.config['user.name'],
             			email: repo.config['user.email'],
             			time: Time.now
         			}

			commit_options = {}
				commit_options[:tree] = index.write_tree(repo)
				commit_options[:author] = user
				commit_options[:committer] = user
				commit_options[:parents] = repo.empty? ? [] : [ repo.head.target ].compact
				commit_options[:update_ref] = 'HEAD'

			if modified.empty? == false then


				m = modified
				index.add_all
				index.write
				commit_options[:message] ||= "#{m} modified at "+"#{Time.now}"
				Rugged::Commit.create(repo,commit_options)
				puts "File Modified".yellow
			end

			if added.empty? == false then
				a = added
				#a.sub('[',' ')
				#a.sub(']',' ')
				index.add_all
				index.write
				commit_options[:message] ||= " #{a} added at "+"#{Time.now}"
				Rugged::Commit.create(repo,commit_options)
				puts "File Added".green
			end

			if removed.empty? == false then
				r = removed
				commit_options[:message] ||= "#{r} removed at "+"#{Time.now}"
				Rugged::Commit.create(repo, commit_options)
				puts "File Removed".red
			end

			
		end
		if option == "start"
		puts "Listener active"	
		listener.start
		end
		
		if option == "stop"
		puts "Listener Stopped"	
		daemon.stop
		listener.stop
		end	



		end
		#listener.start
		
		#stop  = STDIN.gets
		#	if stop == 'stop'
		#		puts "Listener stopped"
		#		listener.stop
				
		#	end	
		#	if stop.to_i == 1
		#			abort"Listener stopped"
		#			listener.stop		
		#	end	
		#listener.stop
	end
end