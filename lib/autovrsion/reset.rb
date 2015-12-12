class Reset
  def reset(path)
    repo = Git.open(path)
    repo.reset
    repo.checkout('master')
    STDOUT.puts "Repository reset to latest version".green
  end
end
