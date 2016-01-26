require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'x', size: 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'x' }
end

class OurWorker
  include Sidekiq::Worker

  # To use OurWorker manually, just call the instance method:
  #
  #     OurWorker.new.perform(:super_hard)
  #
  # The argument can be one of :super_hard, :hard, or anything else (which will
  # presume easy work)
  #
  # To start the sidekiq worker:
  #
  #     $ sidekiq -r ./worker.rb
  #
  # To create a new job for it to perform in the background:
  #
  #     $ irb -r ./examples/por.rb
  #     > OurWorker.perform_async :super_hard

  def perform(complexity)
    case complexity
    when :super_hard
      sleep 20
      puts "Really took quite a bit of effort"
    when :hard
      sleep 10
      puts "That was a bit of work"
    else
      sleep 1
      puts "That wasn't a lot of effort"
    end
  end
end
