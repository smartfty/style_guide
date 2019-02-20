class ArticleWorker
  include SuckerPunch::Job

  def perform(path, time_stamp)
    puts "in ArticleWorker"
    puts "path:#{path}"
    if time_stamp
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article .  -time_stamp=#{time_stamp}"
      # system "cd #{File.dirname(path)} && /Applications/newsman.app/Contents/MacOS/newsman section .  -time_stamp=#{time_stamp}"
    else
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    end
  end
end
