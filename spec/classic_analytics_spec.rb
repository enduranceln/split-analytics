require 'spec_helper'

describe Split::Analytics::ClassicAnalytics do
  include Split::Helper


  it "should generate valid analytics javascript" do
    tracking_code = tracking_code(:account => 'UA-12345-6')
    expect(tracking_code).to eql("        <script type=\"text/javascript\">\n          var _gaq = _gaq || [];\n          _gaq.push(['_setAccount', 'UA-12345-6']);\n          \n          \n          _gaq.push(['_trackPageview']);\n          (function() {\n            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n            ga.src = ('https:' == document.location.protocol ? 'https://ssl.google-analytics.com/ga.js' : 'http://www.google-analytics.com/ga.js');\n            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n          })();\n        </script>\n")
  end

  it "should generate valid analytics javascript with arbitrary tracker object methods" do
    tracker_methods = {
      :setDomainName => "example.com", # String argument
      :setAllowLinker => true, # Boolean argument
      :clearOrganic => "" # No argument
    }
    tracking_code = tracking_code(:account => 'UA-12345-6', :tracker_methods => tracker_methods)
    expect(tracking_code).to eql("        <script type=\"text/javascript\">\n          var _gaq = _gaq || [];\n          _gaq.push(['_setAccount', 'UA-12345-6']);\n          _gaq.push(['_setDomainName', 'example.com']);\n_gaq.push(['_setAllowLinker', true]);\n_gaq.push(['_clearOrganic']);\n          \n          _gaq.push(['_trackPageview']);\n          (function() {\n            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n            ga.src = ('https:' == document.location.protocol ? 'https://ssl.google-analytics.com/ga.js' : 'http://www.google-analytics.com/ga.js');\n            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n          })();\n        </script>\n")
  end

  it "should add custom variables for every test the user is involved in" do
    first_alt = ab_test('link_color', 'red', 'blue')
    second_alt = ab_test('link_text', 'Join', 'Signup')

    tracking_code = tracking_code(:account => 'UA-12345-6')
    expect(tracking_code).to eql("        <script type=\"text/javascript\">\n          var _gaq = _gaq || [];\n          _gaq.push(['_setAccount', 'UA-12345-6']);\n          \n          _gaq.push(['_setCustomVar', 1, 'link_color', '#{first_alt}', 1]);\n_gaq.push(['_setCustomVar', 2, 'link_text', '#{second_alt}', 1]);\n          _gaq.push(['_trackPageview']);\n          (function() {\n            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n            ga.src = ('https:' == document.location.protocol ? 'https://ssl.google-analytics.com/ga.js' : 'http://www.google-analytics.com/ga.js');\n            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n          })();\n        </script>\n")
  end

  it "uses doubleclick as tracker url" do
    tracking_code = tracking_code(:account => 'UA-12345-6', :tracker_url => 'stats.g.doubleclick.net/dc.js', :ssl_tracker_url => 'stats.g.doubleclick.net/dc.js')
    expect(tracking_code).to eql("        <script type=\"text/javascript\">\n          var _gaq = _gaq || [];\n          _gaq.push(['_setAccount', 'UA-12345-6']);\n          \n          \n          _gaq.push(['_trackPageview']);\n          (function() {\n            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;\n            ga.src = ('https:' == document.location.protocol ? 'https://stats.g.doubleclick.net/dc.js' : 'http://stats.g.doubleclick.net/dc.js');\n            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);\n          })();\n        </script>\n")
  end
end
