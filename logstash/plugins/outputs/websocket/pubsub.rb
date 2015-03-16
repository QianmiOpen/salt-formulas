# encoding: utf-8
require "logstash/namespace"
require "logstash/outputs/websocket"
require "json"

class LogStash::Outputs::WebSocket::Pubsub
  attr_accessor :logger

  def initialize
    @hashsubs = Hash.new
    @subscribers = []
    @subscribers_lock = Mutex.new
  end # def initialize

  def publish(object)
    @subscribers_lock.synchronize do
      begin 
        jsonEvent = JSON.parse(object)
        sourceHost = jsonEvent.fetch("host")
        logType = jsonEvent.fetch("type")
        
        break if !@hashsubs.has_key?("#{sourceHost}:#{logType}") || @hashsubs["#{sourceHost}:#{logType}"].size == 0
        
        failed = []

        @hashsubs["#{sourceHost}:#{logType}"].each do |subscriber|
          begin
            @logger.info("object is ", :object => object, :subscriber => subscriber)
            subscriber.call(object) #object is message
          rescue => e1
            @logger.error("Failed to publish to subscriber", :subscriber => subscriber, :exception => e1)
            failed << subscriber
          end
        end

        failed.each do |subscriber|
          @hashsubs["#{sourceHost}:#{logType}"].delete(subscriber)
        end
      rescue Exception => e
        @logger.warn("event parse to json get a error", :exception => e)
        break
      end
#=========================================
      # break if @subscribers.size == 0

      # failed = []
      # @subscribers.each do |subscriber|
        # begin
          # @logger.info("object is ", :object => object, :subscriber => subscriber)
          # subscriber.call(object) #object is message
        # rescue => e
          # @logger.error("Failed to publish to subscriber", :subscriber => subscriber, :exception => e)
          # failed << subscriber
        # end
      # end

      # failed.each do |subscriber|
        # @subscribers.delete(subscriber)
      # end
    end # @subscribers_lock.synchronize
  end # def Pubsub

  def subscribe(taskId, type, &block)
    queue = Queue.new
    @subscribers_lock.synchronize do
      if ! @hashsubs.has_key?("#{taskId}:#{type}")
        @hashsubs["#{taskId}:#{type}"] = []
      end
      @hashsubs["#{taskId}:#{type}"] << proc do |event|
        queue << event
      end
      @logger.info(@hashsubs)
      ##===================
      # @subscribers << proc do |event|
        # jsonEvent = JSON.parse(event)
        # sourceHost = jsonEvent.fetch("host")
        # logType = jsonEvent.fetch("type")
        # puts "sourceHost is #{sourceHost}"
        # if(sourceHost == taskId.to_s && type == logType)
          # queue << event
        # end
      # end
      # @logger.info(@subscribers)
    end

    while true
      @logger.info(@subscribers)
      block.call(queue.pop)
    end
  end # def subscribe
end # class LogStash::Outputs::WebSocket::Pubsub
