module Ah
  module Lograge
    module HTTParty
      class Railtie < ::Rails::Railtie
        STRIP_SUFFIX = %r[.ahinternal.net]
        PREFIX = 'http_'

        config.after_initialize do |app|
          Ah::Lograge::HTTParty::LogSubscriber.attach_to :http
          if !app.config.lograge.enabled && Rails.env.development?
            ActiveSupport.on_load(:action_controller) do
              include Ah::Lograge::HTTParty::ControllerRuntime
            end
          end
          previous_additional_custom_entries_block = nil
          if Ah::Lograge.additional_custom_entries_block.respond_to?(:call)
            previous_additional_custom_entries_block = Ah::Lograge.additional_custom_entries_block
          end
          Ah::Lograge.additional_custom_entries do |event|
            http_runtime = Ah::Lograge::HTTParty::LogSubscriber.reset_runtime
            # there might be a custom block defined already
            if previous_additional_custom_entries_block
              http_runtime.merge!(previous_additional_custom_entries_block.call(event))
            end
            http_runtime
          end
        end
      end
    end
  end
end
