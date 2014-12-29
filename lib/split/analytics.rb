%w[classic universal].each do |f|
  require "split/analytics/#{f}_analytics"
end
module Split
  module Analytics
    include Split::Analytics::ClassicAnalytics
    include Split::Analytics::UniversalAnalytics
  end
end

module Split::Helper
  include Split::Analytics
end

if defined?(Rails)
  class ActionController::Base
    ActionController::Base.send :include, Split::Analytics
    ActionController::Base.helper Split::Analytics
  end
end
