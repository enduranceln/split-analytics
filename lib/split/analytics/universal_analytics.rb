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
        options.each{|key, value| js_options[key.to_s.gsub(/_([a-z])/){|x| x[1].upcase}] = value}

        code = "<script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', '#{account}', #{js_options.to_json.gsub("\"","\'")});
            ga('require', 'displayfeatures');
            #{ dimensions.collect do |dimension|
              "ga('set', '#{dimension.id}', '#{dimension.variation_name}');"
            end.join() }
            var fakeLocation = window.location.pathname + window.location.search;
            var makeFakeLocation = function(data) {
              var parts = fakeLocation.split('/');
              return fakeLocation = parts.slice(0, parts.length-1).join('/') + encodeURIComponent(data) + '/' + parts[parts.length-1];
            }
            #{ split_data_values.collect do |data|
             "makeFakeLocation('#{data}');"
            end.join() }
            #{"ga('send', 'pageview', fakeLocation);" unless disabled }
          </script>"

        if !disabled && experiment_happening?
          code << "<script src='//www.google-analytics.com/cx/api.js'></script>
            <script>
              cxApi.setCookiePath('#{js_options['cookiePath']}');
              cxApi.setDomainName('#{js_options['cookieDomain']}');
              var sendExperimentData = function(tracker, experimentVar, experimentId, experimentName) {
                cxApi.setChosenVariation(experimentVar, experimentId);
                tracker.send('event', 'experiment', 'view', experimentName, {'nonInteraction': 1, 'page': fakeLocation});
              }
              ga(function(tracker) {
                #{ experiments.collect do |experiment|
                  "sendExperimentData(tracker, #{experiment.variation}, '#{experiment.id}', '#{experiment.name}');\n"
                end.join() }
              });
            </script>"
        end
        code
      end

      def experiment_happening?
        split_data.keys.any? && experiments.any?
      end

      def split_data_values
        split_data_keys.collect{|key| split_data[key]}
      end

      def experiments
        split_data_keys.collect{|key| Split::GAExperiment.new(key, split_data[key])}.select{|v| !v.id.nil? && !v.variation.nil?}
      end

      def dimensions
        split_data_keys.collect{|key| Split::GADimension.new(key, split_data[key])}.select{|v| !v.id.nil? }
      end

      def split_data_keys
        @split_data_keys ||= split_data.keys.select{|x| !x.include?(":finished")}
      end
    end
  end
end
