# encoding: utf-8
require "logstash/namespace"
require "logstash/outputs/websocket"
require "sinatra/base"
require "rack/handler/ftw" # from ftw
require "ftw/websocket/rack" # from ftw

class LogStash::Outputs::WebSocket::App < Sinatra::Base
  def initialize(pubsub, logger)
    @pubsub = pubsub
    @logger = logger
  end

  set :reload_templates, false

  get "/:taskId/:type" do |taskId, type|
    # TODO(sissel): Support filters/etc.
    # params = request.env['rack.request.query_hash']
    # puts "taskId is #{params[:taskId]}"
    puts "taskId is #{taskId}"
    ws = ::FTW::WebSocket::Rack.new(env)
    @logger.debug("New websocket client")
    stream(:keep_open) do |out|
      puts "out is #{out}"
      @pubsub.subscribe(taskId, type) do |event|
        event.force_encoding 'ASCII-8BIT'
        ws.publish(event)
      end # pubsub
    end # stream

    ws.rack_response
  end # get /
end # class LogStash::Outputs::WebSocket::App

