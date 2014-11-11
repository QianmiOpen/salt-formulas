# encoding: utf-8
require "logstash/namespace"
require "logstash/outputs/websocket"
require "json"

class LogStash::Outputs::WebSocket::Pubsub
  attr_accessor :logger

  def initialize
    @subscribers = []
    @subscribers_lock = Mutex.new
  end # def initialize

  def publish(object)
    @subscribers_lock.synchronize do
      break if @subscribers.size == 0

      failed = []
      @subscribers.each do |subscriber|
        begin
          @logger.info("object is ", :object => object, :subscriber => subscriber)
          subscriber.call(object) #object is message
        rescue => e
          @logger.error("Failed to publish to subscriber", :subscriber => subscriber, :exception => e)
          failed << subscriber
        end
      end

      failed.each do |subscriber|
        @subscribers.delete(subscriber)
      end
    end # @subscribers_lock.synchronize
  end # def Pubsub

  def subscribe(taskId, &block)
    puts "this params taskId #{taskId}"
    queue = Queue.new
    @subscribers_lock.synchronize do
      @subscribers << proc do |event|
        jsonEvent = JSON.parse(event)
        message = jsonEvent['message']
        puts event
        puts "#{message}"
        if(message.to_s == taskId.to_s)
          queue << event
        end
      end
      @logger.info(@subscribers)
    end

    while true
      @logger.info(@subscribers)
      block.call(queue.pop)
    end
  end # def subscribe
end # class LogStash::Outputs::WebSocket::Pubsub
