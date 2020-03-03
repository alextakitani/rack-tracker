# frozen_string_literal: true

module Rack
  class Tracker
    class Railtie < ::Rails::Railtie
      initializer 'rack-tracker.configure_controller' do |_app|
        ActiveSupport.on_load :action_controller do
          include Rack::Tracker::Controller
        end
      end
    end
  end
end
