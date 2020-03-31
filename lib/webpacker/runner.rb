module Webpacker
  class Runner
    def self.run(argv)
      $stdout.sync = true

      new(argv).run
    end

    def self.check_yarn_integrity!
      `yarn check --integrity && yarn check --verify-tree 2>&1`
    end

    def initialize(argv)
      @argv = argv

      @app_path              = File.expand_path(".", Dir.pwd)
      @node_modules_bin_path = ENV["WEBPACKER_NODE_MODULES_BIN_PATH"] || `yarn bin`.chomp
      @webpack_config        = File.join(@app_path, "config/webpack/#{ENV["NODE_ENV"]}.js")

      unless File.exist?(@webpack_config)
        $stderr.puts "webpack config #{@webpack_config} not found, please run 'bundle exec rails webpacker:install' to install Webpacker with default configs or add the missing config file for your custom environment."
        exit!
      end
    end

    def config
      @config ||= Configuration.new(
        root_path: app_root,
        config_path: app_root.join("config/webpacker.yml"),
        env: ENV["RAILS_ENV"]
      )
    end

    def app_root
      @app_root ||= Pathname.new(@app_path)
    end

    def check_yarn_integrity!
      return unless check_yarn_integrity?

      output = Webpacker::Runner.check_yarn_integrity!

      unless $?.success?
        $stderr.puts "\n\n"
        $stderr.puts "========================================"
        $stderr.puts "  Your Yarn packages are out of date!"
        $stderr.puts "  Please run `yarn install --check-files` to update."
        $stderr.puts "========================================"
        $stderr.puts "\n\n"
        $stderr.puts "To disable this check, please change `check_yarn_integrity`"
        $stderr.puts "to `false` in your webpacker config file (config/webpacker.yml)."
        $stderr.puts "\n\n"
        $stderr.puts output
        $stderr.puts "\n\n"

        exit(1)
      end
    end

    def check_yarn_integrity?
      ENV.fetch("WEBPACKER_CHECK_YARN_INTEGRITY", config.check_yarn_integrity?.to_s) != "false"
    end
  end
end
