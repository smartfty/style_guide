class WireServiceWorker
  # include Sidekiq::Worker
  include SuckerPunch::Job

  def perform
    puts "in perform of WireServiceWorker ..."
    YNewsML.new_ytn
  end
end