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

          ga('create', '#{account}', #{js_options.to_json});
          ga('require', 'displayfeatures');
          #{"ga('send', 'pageview', #{universal_custom_variables});" unless disabled }
        </script>
        <!-- End Google Analytics -->
        EOF
        code
      end

      def universal_custom_variables
        return {} unless split_data.keys.any?
        arr = {}
        split_data.keys.each do |key|
          experiment = Split::Experiment.find(key.gsub(/:\d/, ''))
          arr[experiment.dimension] = split_data[key]
        end
        arr.to_json
      end
    end
  end
end
