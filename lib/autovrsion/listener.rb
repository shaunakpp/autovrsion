module Autovrsion
  # Listens to changes in the repository
  # automatically commits after every modification
  class Listener
    UNTITLED_DOCUMENT_REGEX = %r{^^[/[a-zA-Z]*]*["Untitled Document"]}
    GIT_FILE_REGEX = %r{^[/[a-zA-Z]*]*[".git"]}

    def initialize(path)
      @path = path
      @repository = Rugged::Repository.new(@path)
      @index = @repository.index
    end

    def user
      {
        name: @repository.config['user.name'],
        email: @repository.config['user.email'],
        time: Time.now
      }
    end

    def commit_options
      {
        author: user.clone,
        committer: user.clone,
        parents: (@repository.empty? ? [] : [@repository.head.target].compact),
        update_ref: 'HEAD'
      }
    end

    def listen
      listener_object = listener
      listener_object.start
      stop = STDIN.gets
      if stop == 'stop' || stop.to_i == 1
        listener_object.stop
        abort 'Listener stopped'
      end
    rescue Errno::ENOENT
      STDOUT.puts 'Path does not exist'.red
    end

    def listener
      Listen.to(path, only: [UNTITLED_DOCUMENT_REGEX, GIT_FILE_REGEX]) do |modified, added, removed|
        file_modified(modified)
        file_created(added)
        file_removed(removed)
      end
    end

    def file_modified(modified_files)
      return if modified_files.empty?
      @index.reload
      modified_files.each do |x|
        @index.add(x.delete!(%r{[a-zA-Z]*[/]}))
      end
      options = commit_options.clone
      options[:tree] = @index.write_tree(@repository)
      @index.write
      modified_files.each do |x|
        file_name = x.delete(%r{(\[)(/[a-zA-Z]*)*(/)}).delete(']')
        STDOUT.puts file_name
      end
      options[:message] = "#{modified_files} modified at #{Time.now}"
      Rugged::Commit.create(@repository, options)
      STDOUT.puts 'File Modified'.yellow
    end

    def file_created(added)
      return if added.empty?
      @index.reload
      added.each do |x|
        file_name = x.delete(%r{[a-zA-Z]*[/]})
        next if file_name =~ /Untitled Document/i
        @index.add(x.to_s)
        STDOUT.puts file_name
      end
      options = commit_options.clone
      options[:tree] = @index.write_tree @repository
      @index.write
      options[:message] = " #{added} added at #{Time.now}"
      Rugged::Commit.create(@repository, options)
      STDOUT.puts 'File Added'.green
    end

    def file_deleted(removed_files)
      return if removed_files.empty?
      @index.reload
      @index.add_all
      options = commit_options.clone
      options[:tree] = @index.write_tree(@repository)
      @index.write
      options[:message] = "#{removed_files} removed at #{Time.now}"
      Rugged::Commit.create(@repository, options)
      options.delete(:tree)
      STDOUT.puts 'File Removed'.red
    end
  end
end
