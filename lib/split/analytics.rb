require "split/ga_experiment"
%w[classic universal].each do |f|
  require "split/analytics/#{f}_analytics"
end

module Split
  module Analytics

    def tracking_code(options={})
      code = ClassicAnalytics.new(ab_user).tracking_code(options)
      raw_code(code)
    end

    def universal_tracking_code(options={})
      code = UniversalAnalytics.new(ab_user).universal_tracking_code(options)
      raw_code(code)
    end

    def raw_code(code)
      defined?(raw) ? raw(code) : code
    end
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
