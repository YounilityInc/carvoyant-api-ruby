require 'rubygems'
require 'fakeweb'
require 'minitest/autorun'
require 'mocha/setup'
require 'byebug'
require 'timecop'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'carvoyant-api-ruby'

FakeWeb.allow_net_connect = false

# setup ShopifyAPI with fake api_key and secret

class Minitest::Test
  def self.test(string, &block)
    define_method("test:#{string}", &block)
  end

  def self.should(string, &block)
    self.test("should_#{string}", &block)
  end

  def self.context(string)
    yield
  end

  def setup
  end

  def teardown
    FakeWeb.clean_registry
  end

  # Custom Assertions
  def assert_not(expression)
    assert_block("Expected <#{expression}> to be false!") { not expression }
  end

  def load_fixture(name, format=:json)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.#{format}")
  end

  def fake(endpoint, options={})

    body   = options.has_key?(:body) ? options.delete(:body) : load_fixture(endpoint)
    format = options.delete(:format) || :json
    method = options.delete(:method) || :get
    extension = ".#{options.delete(:extension)||'json'}" unless options[:extension]==false

    url = if options.has_key?(:url)
      options[:url]
    else
      "https://api.carvoyant.com#{endpoint}"
    end

    FakeWeb.register_uri(method, url, {:body => body, :status => 200, :content_type => "text/#{format}", :content_length => 1}.merge(options))
  end
end
