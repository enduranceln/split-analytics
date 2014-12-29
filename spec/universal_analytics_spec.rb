require 'spec_helper'

describe Split::Analytics::UniversalAnalytics  do
  include Split::Helper

  describe "basic configuration" do
    it "should generate valid analytics javascript" do
      tracking_code = universal_tracking_code('UA-12345-6')
      expect(tracking_code).to eql(Result.empty)
    end

    it "should generate valid js with cookie domain" do
      tracking_code = universal_tracking_code('UA-12345-6', { cookie_domain: "example.com"})
      expect(tracking_code).to eql(Result.with_cookies)
    end

    it "should generate valid js with cookie domain" do
      tracking_code = universal_tracking_code('UA-12345-6', { cookie_domain: "example.com", cookie_path: "/cookies" })
      expect(tracking_code).to eql(Result.with_path_to_cookies)
    end

    it "should be disabled when not enabled" do
      tracking_code = universal_tracking_code('UA-12345-6', { disabled: true })
      expect(tracking_code).to eql(Result.disabled)
    end
  end

  describe "with variables" do
    it "should add custom variables for every test the user is involved in" do
      experiment = Split::Experiment.find_or_create("link_color", "blue", "red")
      @ab_user = { experiment.key => "blue", experiment.finished_key => true }
      tracking_code = universal_tracking_code('UA-12345-6', { cookie_domain: "example.com", cookie_path: "/cookies" })
      expect(tracking_code).to eql(Result.with_variables)
    end
  end
end
