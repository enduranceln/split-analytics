require "split/helper"

module Split
  module Analytics
    module UniversalAnalytics

      def universal_tracking_code(account, options={})
        disabled = options.delete(:disabled)
        js_options = {}
        options.each{|key, value| js_options[key.to_s.split('_').collect(&:capitalize).join] = value}

        code = <<-EOF
        <!-- Google Analytics -->
        <script>
          (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
          })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

          ga('create', '#{account}', #{js_options.to_json});
          ga('require', 'displayfeatures');
          #{"ga('send', 'pageview', #{universal_custom_variables});" unless disabled }
        </script>
        <!-- End Google Analytics -->
        EOF

        defined?(raw) ? raw(code) : code
      end

      def universal_custom_variables
        ab_user.to_json
      end
    end
  end
end
