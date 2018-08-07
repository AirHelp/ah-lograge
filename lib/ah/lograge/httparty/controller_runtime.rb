module Ah
  module Lograge
    module HTTParty
      module ControllerRuntime
        extend ActiveSupport::Concern

        protected

        attr_internal :ah_http_runtime

        def append_info_to_payload(payload)
          super
          http_runtime = Ah::Lograge::HTTParty::LogSubscriber.reset_runtime
          payload[:ah_http_runtime] = http_runtime
        end

        module ClassMethods
          def log_process_action(payload)
            messages, http_runtime = super, payload[:ah_http_runtime]
            http_runtime.each do |service, time|
              if time > 0
                messages << ("Http(#{ service }): %.1fms" % time)
                if defined?(Statsd) && defined?($statsd)
                  $statsd.timing("http/#{ service }", time)
                end
              end
            end
            messages
          end
        end
      end
    end
  end
end

