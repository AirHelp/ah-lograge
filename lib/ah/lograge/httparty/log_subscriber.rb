module Ah
  module Lograge
    module HTTParty
      class LogSubscriber < ActiveSupport::LogSubscriber
        def self.add_runtime(hostname, duration)
          Thread.current[:ah_http_runtime] ||= Hash.new(0)
          Thread.current[:ah_http_runtime][hostname] += duration
        end

        def self.reset_runtime
          rt = Thread.current[:ah_http_runtime]
          Thread.current[:ah_http_runtime] = Hash.new(0)
          rt
        end

        def request(event)
          self.class.add_runtime(event.payload[:hostname], event.duration)
        end
      end
    end
  end
end
