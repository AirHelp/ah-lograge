require 'ah/lograge/httparty/instrumentation'
if defined? ::Rails
  require 'ah/lograge/httparty/controller_runtime'
  require 'ah/lograge/httparty/log_subscriber'
  require 'ah/lograge/httparty/railtie'
end
