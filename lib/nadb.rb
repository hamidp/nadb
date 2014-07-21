require 'nadb/version'

require 'json'
require 'optparse'

module Nadb
  class Tool
    def initialize
      @config = {}
      @options = {}

      load_config

      @opt_parse = OptionParser.new do |opts|
        opts.banner = <<eos
A nicer interface to adb.
Usage: nadb [options] command

Options:
eos
        @options[:all] = false
        opts.on('--all', 'Run command on all connected devices') { @options[:all] = true }

        @options[:name] = nil
        opts.on('-n', '--name NAME', 'Name of device to run from') { |name| @options[:name] = name }

        @options[:index] = nil
        opts.on('-i',
                '--index INDEX',
                OptionParser::DecimalInteger,
                'The index of the target device in the adb devices output') { |index| @options[:index] = index }

        opts.on('-h', '--help', 'Display this screen') do
          puts opts
          exit
        end
      end
    end

    # Load config from the file if any exists
    def load_config
      path = ENV['HOME'] + '/.nadb.config'
      if !File.exists?(path)
        return
      end

      @config = JSON.parse(File.read(path))
    end

    def adb_path
      ENV['ANDROID_HOME'] + '/platform-tools/adb'
    end

    # Construct an adb command
    def construct_adb_command(command, device = nil)
      device_specifier = device.nil? ? "" : " -s #{device}"
      "#{adb_path}#{device_specifier} #{command}"
    end

    def get_adb_command_output(command)
      full_command = construct_adb_command command
      IO.popen(full_command + ' 2>&1', 'w+')
    end

    # Run an adb commd on specified device, optionally printing the output
    def run_adb_command(command, device = nil)
      full_command = construct_adb_command command, device
      
      puts full_command
      pio = IO.popen(full_command, 'w')
      Process.wait(pio.pid)
    end

    # Get all currently connected android devices
    def get_connected_devices
      get_adb_command_output('devices')
      .drop(1)
      .map { |line| line.split[0] }
      .reject { |d| d.nil? || d.empty? }
    end

    # Bakes fresh cookies.
    def run(argv)
      dup_argv = argv.dup
      begin
        @opt_parse.order! dup_argv
      rescue OptionParser::InvalidOption => e
      end

      command_to_run = dup_argv.join " "

      # Run on all devices
      if @options[:index]
        devices = get_connected_devices
        device = devices[@options[:index]]
        if device.nil?
          raise "Requested device #{@options[:index]} but only have #{devices.length} devices connected."
        end

        run_adb_command command_to_run, device

        return
      end

      # Run on all connected devices
      if @options[:all]
        devices = get_connected_devices
        devices.each do |device|
          run_adb_command command_to_run, device
        end
        return
      end

      # Just pass everything to adb as we got it
      passthrough_command = argv.join " "
      run_adb_command passthrough_command
    end
  end
end
