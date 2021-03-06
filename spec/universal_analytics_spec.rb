require 'spec_helper'

describe Split::Analytics::UniversalAnalytics  do
  include Split::Helper

  context "without variables" do
    it "should generate valid analytics javascript" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6')
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.empty.gsub(/\s+/, ""))
    end

    it "should generate valid js with cookie domain" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com")
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.with_cookies.gsub(/\s+/, ""))
    end

    it "should generate valid js with cookie domain and path" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com", cookie_path: "/cookies")
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.with_path_to_cookies.gsub(/\s+/, ""))
    end

    it "should not send pageview when disabled" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', disabled: true)
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.disabled.gsub(/\s+/, ""))
    end
  end

  context "with variables" do
    it "should add custom variables for every test the user is involved in" do
      variable1 = ab_test('link_color', 'red', 'blue')
      variable2 = ab_test('link_text', 'Join', 'Signup')
      variable3 = ab_test('kittens', 'Ninja', 'Wildberry')

      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com", cookie_path: "/cookies")
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.with_variables(variable1, variable2, variable3).gsub(/\s+/, ""))

      finished('link_color')
      finished('link_text')
      finished('kittens')

      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com", cookie_path: "/cookies")
      expect(tracking_code.gsub(/\s+/, "")).to eql(Result.with_path_to_cookies.gsub(/\s+/, ""))
    end
  end
end
