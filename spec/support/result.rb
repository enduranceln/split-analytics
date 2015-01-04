class Result
  class << self
    def empty
      <<-EOF
          <!-- Google Analytics -->
          <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
              (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-12345-6', {});
            ga('require', 'displayfeatures');
            ga('send', 'pageview');
          </script>
          <!-- End Google Analytics -->
      EOF
    end

    def experiments(variable1, variable2)
     a = Split::GAExperiment.new('link_color', variable1)
     b = Split::GAExperiment.new('link_text', variable2)
     code = <<-EOF
            <!-- Google Analytics Experiments -->
            <script src="//www.google-analytics.com/cx/api.js"></script>
            <script>
              cxApi.setCookiePath('/cookies');
              cxApi.setDomainName('example.com');
              cxApi.setChosenVariation(#{a.variation}, '#{a.id}');\ncxApi.setChosenVariation(#{b.variation}, '#{b.id}');
            </script>
            </!-- Google Analytics Experiments -->
      EOF
    end

    def with_cookies
      empty.sub('{}', "{'CookieDomain':'example.com'}")
    end

    def with_path_to_cookies
       empty.sub('{}', "{'CookieDomain':'example.com','CookiePath':'/cookies'}")
    end

    def disabled
      empty.sub("ga('send', 'pageview');", '')
    end

    def with_variables(variable1, variable2)
      experiments(variable1, variable2) + with_path_to_cookies
    end
  end
end
