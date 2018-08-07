module Ah
  module Lograge
    module HTTParty
      module Instrumentation
        extend ActiveSupport::Concern

        class_methods do
          def perform_request(http_method, path, options, &block) #:nodoc:
            uri = URI.parse(base_uri)
            if defined?(Statsd) && defined?($statsd)
              $statsd.increment("http/#{ uri.host }")
            end
            ActiveSupport::Notifications.instrument("request.http", hostname: uri.host) do
              super
            end
          end
        end
      end
    end
  end
end
