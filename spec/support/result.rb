class Result
  class << self
    def empty
      "<script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
        ga('create', 'UA-12345-6', {});
        ga('require', 'displayfeatures');
        ga('send', 'pageview');
      </script>"
    end

    def dimensions
      "<script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
          (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
          m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
        ga('create', 'UA-12345-6', {'cookieDomain':'example.com','cookiePath':'/cookies'});
        ga('require', 'displayfeatures');
        ga('set','#{d_a.id}','#{d_a.variation_name}');
        ga('set','#{d_b.id}','#{d_b.variation_name}');
        ga('send', 'pageview');
      </script>"
    end

    def experiments
     "<script src='//www.google-analytics.com/cx/api.js'></script>
      <script>
        cxApi.setCookiePath('/cookies');
        cxApi.setDomainName('example.com');
        var sendExperimentData = function(tracker, experimentVar, experimentId, experimentName) {
           cxApi.setChosenVariation(experimentVar, experimentId);
           tracker.send('event', 'experiment', 'view', experimentName, {'nonInteraction': 1});
        }
        ga(function(tracker) {
          ga('set','#{d_a.id}','');
          ga('set','#{d_b.id}','');
          sendExperimentData(tracker, #{e_a.variation}, '#{e_a.id}', '#{e_a.name}');
          sendExperimentData(tracker, #{e_b.variation}, '#{e_b.id}', '#{e_b.name}');
        });
      </script>"
    end

    def with_cookies
      empty.sub('{}', "{'cookieDomain':'example.com'}")
    end

    def with_path_to_cookies
       empty.sub('{}', "{'cookieDomain':'example.com','cookiePath':'/cookies'}")
    end

    def disabled
      empty.sub("ga('send', 'pageview');", '')
    end


    def with_variables(variable1, variable2)
      @variable1 = variable1
      @variable2 = variable2
      dimensions + "\n" + experiments
    end

    def d_a
      @d_a ||= Split::GADimension.new('link_color', @variable1)
    end

    def d_b
      @d_b ||= Split::GADimension.new('link_text', @variable2)
    end

    def e_a
      @e_a ||= Split::GAExperiment.new('link_color', @variable1)
    end

    def e_b
      @e_b ||= Split::GAExperiment.new('link_text', @variable2)
    end
  end
end
