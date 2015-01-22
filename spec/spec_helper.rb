# spec/spec_helper.rb
RSpec.configure do |config|
  config.include(Module.new do
    def stub_api_for(klass)
      klass.use_api (api = Her::API.new)

      # Here, you would customize this for your own API (URL, middleware, etc)
      # like you have done in your application’s initializer
      api.setup url: "http://api.example.com" do |c|
        c.use EmberDataActiveModelParser::Middleware
        c.adapter(:test) { |s| yield(s) }
      end
    end
  end)
end
