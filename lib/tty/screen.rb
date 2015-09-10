# coding: utf-8

require 'tty/screen/version'

module TTY
  # Used for detecting screen properties
  #
  # @api public
  class Screen
    # Create terminal screen
    #
    # @param [Hash] options
    # @option options [Object] :output
    #   the object that responds to print call defaulting to stderr
    #
    # @api public
    def initialize(options = {})
      @output = options.fetch(:output) { $stderr }
    end

    # @api public
    def self.size
      new.size
    end

    # @api public
    def self.width
      size[1]
    end

    # @api public
    def self.height
      size[0]
    end

    # Default terminal size
    #
    # @api public
    def default_size
      [
        ENV['LINES'].to_i.nonzero? || 27,
        ENV['COLUMNS'].to_i.nonzero? || 80
      ]
    end

    # Terminal lines count
    #
    # @return [Integer]
    #
    # @api public
    def height
      size[0]
    end
    alias_method :rows, :height

    # Terminal columns count
    #
    # @return [Integer]
    #
    # @api public
    def width
      size[1]
    end
    alias_method :columns, :width

    # Get terminal rows and columns
    #
    # @return [Array[Integer, Integer]]
    #   return rows & columns
    #
    # @api public
    def size
      @size ||= begin
        size =   from_io_console
        size ||= from_readline
        size ||= from_tput
        size ||= from_stty
        size ||= from_env
        size ||= from_ansicon
        size ||  default_size
      end
    end

    # Detect screen size by loading io/console lib
    #
    # @return [Array[Integer, Integer]]
    #
    # @api private
    def from_io_console
      return false if jruby?
      try_io_console { |size|
        size if nonzero_column?(size[1])
      }
    end

    # Attempts to load native console extension
    #
    # @return [Boolean, Array]
    #
    # @api private
    def try_io_console
      begin
        require 'io/console'

        begin
          if output.tty? && IO.method_defined?(:winsize)
            yield output.winsize
          else
            false
          end
        rescue Errno::EOPNOTSUPP
          false
        end
      rescue LoadError
        warn 'no native io/console support' if $VERBOSE
        false
      end
    end

    # Detect screen size using Readline
    #
    # @api private
    def from_readline
      return unless defined?(Readline)
      size = Readline.get_screen_size
      size if nonzero_column?(size[1])
    rescue NotImplementedError
    end

    # Detect terminal size from tput utility
    #
    # @api private
    def from_tput
      return unless output.tty?
      lines = run_command('tput', 'lines').to_i
      cols  = run_command('tput', 'cols').to_i
      [lines, cols] if nonzero_column?(lines)
    rescue Errno::ENOENT
    end

    # Detect terminal size from stty utility
    #
    # @api private
    def from_stty
      return unless output.tty?
      size = run_command('stty', 'size').split.map(&:to_i)
      size if nonzero_column?(size[1])
    rescue Errno::ENOENT
    end

    # Detect terminal size from environment
    #
    # @api private
    def from_env
      return unless ENV['COLUMNS'] =~ /^\d+$/
      size = [(ENV['LINES'] || ENV['ROWS']).to_i, ENV['COLUMNS'].to_i]
      size if nonzero_column?(size[1])
    end

    # Detect terminal size on windows
    #
    # @api private
    def from_ansicon
      return unless ENV['ANSICON'] =~ /\((.*)x(.*)\)/
      size = [$2, $1].map(&:to_i)
      size if nonzero_column?(size[1])
    end

    private

    # Specifies an output stream object
    #
    # @api public
    attr_reader :output

    # Runs command in subprocess
    #
    # @api private
    def run_command(command, *args)
      `#{command} #{args.join(' ')} 2>/dev/null`
    end

    def nonzero_column?(column)
      column.to_i > 0
    end

    def jruby?
      RbConfig::CONFIG['ruby_install_name'] == 'jruby'
    end
  end # Screen
end # TTY
