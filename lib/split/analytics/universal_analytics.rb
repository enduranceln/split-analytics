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
        code = ''
        options.each{|key, value| js_options[key.to_s.split('_').collect(&:capitalize).join] = value}

        if experiment_happening?
          code << <<-EOF
            <!-- Google Analytics Experiments -->
            <script src="//www.google-analytics.com/cx/api.js"></script>
            <script>
              cxApi.setCookiePath('#{js_options['CookiePath']}');
              cxApi.setDomainName('#{js_options['CookieDomain']}');
              #{ experiments.collect{|experiment|
                "cxApi.setChosenVariation(#{experiment.variation}, '#{experiment.id}');"
              }.join("\n") }
            </script>
            </!-- Google Analytics Experiments -->
          EOF
        end

        code << <<-EOF
          <!-- Google Analytics -->
          <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', '#{account}', #{js_options.to_json.gsub("\"","\'")});
            ga('require', 'displayfeatures');
            #{"ga('send', 'pageview');" unless disabled }
          </script>
          <!-- End Google Analytics -->
        EOF
        code
      end

      def experiment_happening?
        split_data.keys.any? && experiments.any?
      end

      def experiments
        split_data.keys.collect{|key| Split::GAExperiment.new(key, split_data[key])}
      end
    end
  end
end
