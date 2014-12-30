ENV['RACK_ENV'] = "test"

require 'rubygems'
require 'bundler/setup'
require 'split'
require 'split/helper'
require 'ostruct'
require 'pry'
require 'support/result'
require 'fakeredis/rspec'


Dir['./lib/split/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
  Split.configuration = Split::Configuration.new
  config.before(:each) do
    @ab_user = {}
  end
end

def session
  @session ||= {}
end

def params
  @params ||= {}
end

def request(ua = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; de-de) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27')
  @request ||= OpenStruct.new(ip:'192.168.1.1', user_agent: ua)
end
