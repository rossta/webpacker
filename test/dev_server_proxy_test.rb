require "webpacker_test_helper"

class DevServerProxyTest < Minitest::Test
  include Rack::Test::Methods
  DevServer = Struct.new(:host_with_port, :running?, :https?)

  def app
    Rack::Builder.new do
      map "/" do
        use Webpacker::DevServerProxy
        run ->(_env) { [200, { "Content-Type" => "text/plain" }, ["OK"]] }
      end
    end
  end

  def start_stub_dev_server
    require 'webrick'
    server = WEBrick::HTTPServer.new \
      Port: 3036,
      Logger: WEBrick::Log.new("/dev/null"),
      AccessLog: []
    server.mount "/", WEBrick::HTTPServlet::FileHandler, './test/fixtures/'
    @stub_dev_server_pid = fork do
      trap('TERM') { server.stop }
      server.start
    end
    Process.detach(@stub_dev_server_pid)
  end

  def stop_stub_dev_server
    Process.kill 'TERM', @stub_dev_server_pid.to_i if @stub_dev_server_pid
  end

  def with_stub_dev_server
    start_stub_dev_server
    yield
  ensure
    stop_stub_dev_server
  end

  def test_pack_request
    dev_server_config = DevServer.new("localhost:3036", true)

    with_stub_dev_server do
      Webpacker.stub :dev_server, dev_server_config do
        get "/packs/application.js"
        assert last_response.ok?, "Expected a 200 response but got a #{last_response.status}"
        assert_match(/Hello World from Webpacker/, last_response.body)
      end
    end
  end

  def test_non_pack_request
    get "/"
    assert_match("OK", last_response.body)
  end
end
