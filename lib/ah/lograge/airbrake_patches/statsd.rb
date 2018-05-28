module Ah
  module Lograge
    class Railtie < ::Rails::Railtie
      config.after_initialize do |app|
        if defined?(Statsd) && defined?(Airbrake)
          Airbrake.add_filter do |notice|
            @client ||=  if defined?($statsd) && $statsd.is_a?(Statsd)
              $statsd
            else
              Statsd.new(ENV['STATSD_HOST'])
            end

            @client.increment('exceptions')
          end
        end
      end
    end
  end
end

