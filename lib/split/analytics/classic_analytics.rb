module Split
  module Analytics
    class ClassicAnalytics
      attr_reader :split_data

      def initialize(split_data)
        @split_data = split_data
      end

      def tracking_code(options={})
        # needs more options: http://code.google.com/apis/analytics/docs/gaJS/gaJSApi.html
        account = options.delete(:account)
        tracker_url = options.delete(:tracker_url)
        ssl_tracker_url = options.delete(:ssl_tracker_url)
        tracker_methods = options.delete(:tracker_methods)

        tracker_url = 'http://' + (tracker_url || 'www.google-analytics.com/ga.js')
        ssl_tracker_url = 'https://' + (ssl_tracker_url || 'ssl.google-analytics.com/ga.js')

        code = <<-EOF
        <script type="text/javascript">
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', '#{account}']);
          #{insert_tracker_methods(tracker_methods)}
          #{custom_variables}
          _gaq.push(['_trackPageview']);
          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? '#{ssl_tracker_url}' : '#{tracker_url}');
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        </script>
        EOF
        code
      end

      def custom_variables
        return nil unless split_data.keys.any?
        arr = []
        split_data.each_with_index do |h,i|
          arr << "_gaq.push(['_setCustomVar', #{i+1}, '#{h[0]}', '#{h[1]}', 1]);"
        end
        arr.reverse[0..4].reverse.join("\n")
      end

      private

      def insert_tracker_methods(tracker_methods)
        return nil unless tracker_methods
        arr = []
        tracker_methods.each do |k,v|
          if v.class == String && v.empty?
            # No argument tracker method
            arr << "_gaq.push(['" + "_" + "#{k}']);"
          else
            case v
            when String
              # String argument tracker method
              arr << "_gaq.push(['" + "_" + "#{k}', '#{v}']);"
            when TrueClass, FalseClass
              # Boolean argument tracker method
              arr << "_gaq.push(['" + "_" + "#{k}', #{v}]);"
            when Array
              # Array argument tracker method
              values = v.map { |value| "'#{value}'" }.join(', ')
              arr << "_gaq.push(['" + "_" + "#{k}', #{values}]);"
            end
          end
        end
        arr.join("\n")
      end
    end
  end
end
