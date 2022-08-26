module Sheetq
  module Command
    class Init
      TEMPLATE_DIR = File.expand_path("../../templates", __FILE__)

      def initialize(config_file)
        @shell = Thor.new
        @status = {green: 0, yellow: 0, red: 0}
        config = {}

        config_dir = File.dirname(config_file)

        if File.exists?(File.expand_path(config_file))
          say_status "exist", "Ignore #{config_file}", :red
          return
        end

        say "Creating #{config_file} ..."
        say "Get your CLIENT_ID/CLIENT_SECRET at https://console.developers.google.com", :green
        say "Googling 'Creating a Google API Console project and client ID' would help."

        config[:client_id] = @shell.ask "CLIENT_ID:"
        config[:client_secret] = @shell.ask "CLIENT_SECRET:"
        config[:default_user] = @shell.ask "Gmail address:"
        config[:cache_directory] = "~/.cache/sheetq"
        config[:default_sheet_id] = @shell.ask "DEFAULT_SHEET_ID:"

        # mkdir config_dir
        unless Dir.exist?(File.expand_path(config_dir))
          say "Making config directory #{config_dir} ..."
          mkdir_p(File.expand_path(config_dir))
        end

        # mkdir cache_dir
        cache_dir = config[:cache_directory]
        say "Making cache directory #{cache_dir} ..."
        mkdir_p(File.expand_path(cache_dir))

        # make config file from tamplate
        say "Copying file(s) into #{config_file} ..."
        src = File.expand_path("config.yml.erb", TEMPLATE_DIR)
        dst = File.expand_path(config_file)
        expand_template(src, dst, config)

        say_status_report
      end

      private

      def say(message, color = nil)
        @shell.say(message, color)
      end

      def say_status(status, message, log_status = nil)
        @status[log_status] += 1
        @shell.say_status(status, message, log_status)
      end

      def say_status_report
        if (errors = @status[:red]) > 0
          say "#{errors} error(s) were occurred.", :red
        else
          say "done."
        end
      end

      def expand_template(template_path, dest_path, config)
        require "erb"
        template = ERB.new(File.open(template_path).read, nil, "-")

        if File.exists?(dest_path)
          say_status "exist", "Ignore #{dest_path}", :yellow
          return
        end

        begin
          mkdir_p(File.expand_path("..", dest_path))
          File.open(dest_path, "w", 0600) do |file|
            file.write(template.result(binding))
          end
          say_status "ok", "copy #{dest_path}", :green
        rescue StandardError => e
          say_status "failed", "#{e.message.split(' @').first} #{dest_path}", :red
        end
      end

      def mkdir_p(path)
        abspath = File.expand_path(path)

        if File.directory?(abspath)
          say_status "exist", "Ignore #{path}", :yellow
          return
        end

        begin
          FileUtils.mkdir_p(abspath)
          say_status "create", "#{path}", :green
        rescue StandardError => e
          say_status "failed", "#{e.message.split(' @').first} #{path}", :red
        end
      end

    end # class Init
  end # module Command
end # module Sheetq
