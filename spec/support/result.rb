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

    def experiments(variable1, variable2)
     a = Split::GAExperiment.new('link_color', variable1)
     b = Split::GAExperiment.new('link_text', variable2)
     "<script src='//www.google-analytics.com/cx/api.js'></script>
      <script>
        cxApi.setCookiePath('/cookies');
        cxApi.setDomainName('example.com');
        var sendExperimentData = function(tracker, experimentVar, experimentId) {
           cxApi.setChosenVariation(experimentVar, experimentId);
           tracker.send('event', 'experiment', 'view', experimentId + ':' + experimentVar, {'nonInteraction': 1});
        }
        ga(function(tracker) {
          sendExperimentData(tracker, #{a.variation}, '#{a.id}');
          sendExperimentData(tracker, #{b.variation}, '#{b.id}');
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
      with_path_to_cookies + "\n" + experiments(variable1, variable2)
    end
  end
end
