require 'spec_helper'

describe Split::Analytics::UniversalAnalytics  do
  include Split::Helper

  context "without variables" do
    it "should generate valid analytics javascript" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6')
      expect(tracking_code).to eql(Result.empty)
    end

    it "should generate valid js with cookie domain" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com")
      expect(tracking_code).to eql(Result.with_cookies)
    end

    it "should generate valid js with cookie domain and path" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com", cookie_path: "/cookies")
      expect(tracking_code).to eql(Result.with_path_to_cookies)
    end

    it "should not send pageview when disabled" do
      tracking_code = universal_tracking_code(account: 'UA-12345-6', disabled: true)
      expect(tracking_code).to eql(Result.disabled)
    end
  end

  context "with variables" do
    it "should add custom variables for every test the user is involved in" do
      variable1 = ab_test('link_color', 'red', 'blue')
      variable2 = ab_test('link_text', 'Join', 'Signup')

      tracking_code = universal_tracking_code(account: 'UA-12345-6', cookie_domain: "example.com", cookie_path: "/cookies")
      expect(tracking_code).to eql(Result.with_variables(variable1, variable2))
    end
  end
end
