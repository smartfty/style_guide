require 'rlayout'

class ArticleRubyWorker
  include SuckerPunch::Job

  def perform(path, time_stamp)
    puts "in ArticleWorkerRibu"
    puts "path:#{path}"
    options                 = {}
    options[:article_path]  = path
    options[:jpg]           = true
    if time_stamp
      options[:time_stamp] = time_stamp
    end
    RLayout::NewsBoxMaker.new(options)
  end
end