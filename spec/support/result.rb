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
          ga('send', 'pageview', {});
        </script>
        <!-- End Google Analytics -->
      EOF
    end

    def with_cookies
      empty.sub('{}', '{"CookieDomain":"example.com"}')
    end

    def with_path_to_cookies
      empty.sub('{}', '{"CookieDomain":"example.com","CookiePath":"/cookies"}')
    end

    def disabled
      empty.sub("ga('send', 'pageview', {});", '')
    end

    def with_variables(variable1, variable2)
      e = empty.sub('{}', '{"CookieDomain":"example.com","CookiePath":"/cookies"}')
      e.sub('{}', "{\"dimension1\":\"#{variable1}\",\"dimension2\":\"#{variable2}\"}")
    end
  end
end
