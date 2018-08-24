module Ah
  module Lograge
    module HTTParty
      #
      # that concern is only used on local development with lograge disabled
      # it will log total time spent in http calls to other services along views & db times:
      # (Views: 71.7ms | ActiveRecord: 70.7ms | HttpAirspace: 9820.2ms | HttpHermanStaging: 380.2ms)
      #
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
                messages << ("#{ service.titleize.tr(' ', '') }: %.1fms" % time)
              end
            end
            messages
          end
        end
      end
    end
  end
end

