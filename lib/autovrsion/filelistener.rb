#!/usr/bin/env ruby
module Autovrsion
  class FileListen
    def initialize(path)
      @path = path
      @repo= Rugged::Repository.new(@path)
      @index = @repo.index
      @user =  {
        name: @repo.config['user.name'],
        email: @repo.config['user.email'],
        time: Time.now
      }
      @commit_options = {
        author: @user,
        committer: @user,
        parents: (@repo.empty? ? [] : [ @repo.head.target ].compact),
        update_ref: "HEAD"
      }
    end

    def listen
      begin
        listener = get_listener
        listener.start
			  STDOUT.puts "Listening to changes.enter "+"stop ".red+"or"+" 1 ".red+"to stop listening to changes"
        stop  = STDIN.gets
        if stop == "stop"
          STDOUT.puts "Listener stopped"
          listener.stop
        end

        if stop.to_i == 1
          listener.stop
          abort"Listener stopped"
        end
      rescue Errno::ENOENT
        STDOUT.puts "Path does not exist".red
      end
    end

    def get_listener
      Listen.to(path,only: [/^^[\/[a-zA-Z]*]*["Untitled Document"]/,/^[\/[a-zA-Z]*]*[".git"]/]) do |modified,added,removed|
        file_modified(modified) unless modified.empty?
        file_created(added) unless added.empty?
        file_removed(removed) unless removed.empty?
      end
    end

    def file_modified(modified_files)
      @index.reload
      modified_files.each do |x|
        @index.add(x.gsub!(/[a-zA-Z]*[\/]/,""))
      end

      @commit_options[:tree] = @index.write_tree(@repo)
      @index.write
      modified_files.each do |x|
        file_name = x.gsub(/(\[)(\/[a-zA-Z]*)*(\/)/,"")
        STDOUT.puts file_name.gsub("]","")
      end
      @commit_options[:message] = "#{modified_files} modified at "+"#{Time.now}"
      Rugged::Commit.create(@repo,@commit_options)
      STDOUT.puts "File Modified".yellow
    end

    def file_created(added)
      @index.reload
      added.each do |x|
        file_name = x.gsub(/[a-zA-Z]*[\/]/,"")
        next if file_name =~ /Untitled Document/i
        @index.add("#{x}")
        STDOUT.puts file_name
      end
      @commit_options[:tree] = @index.write_tree @repo
      @index.write
      @commit_options[:message] = " #{added} added at #{Time.now}"
      Rugged::Commit.create(@repo,@commit_options)
      STDOUT.puts "File Added".green
    end

    def file_deleted(removed_files)
      @index.reload
      @index.add_all
      @commit_options[:tree] = @index.write_tree(@repo)
      @index.write
      @commit_options[:message] = "#{removed_files} removed at #{Time.now}"
      Rugged::Commit.create(@repo,@commit_options)
      STDOUT.puts "File Removed".red
      @commit_options.delete(:tree)
    end

  end
end
