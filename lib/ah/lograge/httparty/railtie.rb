module Ah
  module Lograge
    module HTTParty
      class Railtie < ::Rails::Railtie
        config.after_initialize do |app|
          Ah::Lograge::HTTParty::LogSubscriber.attach_to :http
          ActiveSupport.on_load(:action_controller) do
            include Ah::Lograge::HTTParty::ControllerRuntime
          end
        end
      end
    end
  end
end
