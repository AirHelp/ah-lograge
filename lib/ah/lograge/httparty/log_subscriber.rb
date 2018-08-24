module Ah
  module Lograge
    module HTTParty
      class LogSubscriber < ActiveSupport::LogSubscriber
        STRIP_SUFFIX = %r[.ahinternal.net]
        PREFIX = 'http_'
        THREAD_KEY = :ah_lograge_http_runtime

        def self.add_runtime(hostname, duration)
          Thread.current[THREAD_KEY] ||= Hash.new(0)
          Thread.current[THREAD_KEY][hostname] += duration
        end

        def self.reset_runtime
          http_runtime = Thread.current[THREAD_KEY]
          Thread.current[THREAD_KEY] = Hash.new(0)
          return {} unless http_runtime
          http_runtime.keys.each do |hostname|
            http_runtime[service_key(hostname)] = http_runtime[hostname].round(2)
            http_runtime.delete(hostname)
          end
          http_runtime
        end

        def request(event)
          unless Rails.application.config.lograge.enabled
            text = "  HTTP (#{ event.duration.round(2) }ms) to #{ event.payload[:hostname] } completed"
            Rails.logger.debug(color(text, :GREEN, bold=false))
          end
          if defined?(Statsd) && defined?($statsd)
            $statsd.increment("http/count/#{ event.payload[:hostname] }")
            $statsd.timing("http/time/#{ event.payload[:hostname] }", event.duration.round(2))
          end
          self.class.add_runtime(event.payload[:hostname], event.duration)
        end

        private

        def self.service_key(hostname)
          PREFIX + hostname.gsub(STRIP_SUFFIX, '')
        end
      end
    end
  end
end
