module Split
  module Analytics
    class UniversalAnalytics
      attr_reader :split_data

      def initialize(split_data)
        @split_data = split_data
      end

      def universal_tracking_code(options={})
        account = options.delete(:account)
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
          ga('create', '#{account}', #{js_options.to_json.gsub("\"","\'")});
          ga('require', 'displayfeatures');
          #{"ga('set', #{universal_custom_variables});" if split_data.keys.any?}
          #{"ga('send', 'pageview');" unless disabled }
        </script>
        <!-- End Google Analytics -->
        EOF
        code
      end

      def universal_custom_variables
        arr = {}
        split_data.keys.each do |key|
          dimension = Split::Dimension.find(key.gsub(/:\d/, ''))
          arr[dimension] = split_data[key]
        end
        arr.to_json.gsub("\"","\'")
      end
    end
  end
end
