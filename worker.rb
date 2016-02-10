require 'sidekiq'

# We'll configure the Sidekiq client to connect to redis using a custom
# DB - this way we can run multiple apps on the same redis without them
# stepping on each other

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

# We'll configure the Sidekiq server as well

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

class OurWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  # To use OurWorker manually, just call the instance method:
  #
  #     OurWorker.new.perform("super_hard")
  #
  # The argument can be one of "super_hard", "hard", or anything else (which will
  # presume easy work)
  #
  # To start the sidekiq worker:
  #
  #     $ bundle exec sidekiq -r ./worker.rb
  #
  # To create a new job for it to perform in the background:
  #
  #     $ bundle exec irb -r ./worker.rb
  #     > OurWorker.perform_async "super_hard"

  def perform(complexity)
    case complexity
    when "super_hard"
      puts "charging a credit card"
      raise "Woops stuff got bad"
      puts "Really took quite a bit of effort"
    when "hard"
      sleep 10
      puts "That was a bit of work"
    else
      sleep 1
      puts "That wasn't a lot of effort"
    end
  end
end
