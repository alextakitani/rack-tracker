# frozen_string_literal: true

class Rack::Tracker::HandlerDelegator
  class << self
    delegate :handler, to: :new
  end

  attr_accessor :env

  def initialize(env = {})
    @env = env
  end

  def method_missing(method_name, *args, &block)
    if respond_to?(method_name)
      handler(method_name).process_track(env, method_name, *args, &block)
    else
      super
    end
  end

  def respond_to?(method_name, include_private = false)
    handler(method_name).respond_to?(:track, include_private)
  end

  def handler(method_name)
    return method_name if method_name.is_a?(Class)

    _handler = method_name.to_s.camelize
    ["Rack::Tracker::#{_handler}", _handler].detect do |const|
      return const.constantize
    rescue NameError
      false
    end

    raise ArgumentError, "No such Handler: #{_handler}"
  end
end
