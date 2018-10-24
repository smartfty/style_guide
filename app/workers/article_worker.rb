class ArticleWorker
  include Sidekiq::Worker

  def perform(path, time_stamp, publication)
    puts "in ArticleWorker"
    puts "path:#{path}"
    if time_stamp && publication
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article .  -custom=#{publication} -time_stamp=#{time_stamp}"
      
      system "cd #{File.dirname(path)} && /Applications/newsman.app/Contents/MacOS/newsman section .  -time_stamp=#{time_stamp}"

    elsif publication
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article .  -custom=#{publication}"
    else
      system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman article ."
    end
  end
end
