require 'optparse'
require 'ostruct'

require 'bento/common'
require 'bento/build'
require 'bento/build_remote'
require 'bento/delete'
require 'bento/normalize'
require 'bento/release'
require 'bento/revoke'
require 'bento/test'
require 'bento/upload'


class Options

  NAME = File.basename($0).freeze

  def self.parse(args)
    options = OpenStruct.new
    options.templates = calculate_templates("*.json")

    global = OptionParser.new do |opts|
      opts.banner = "Usage: #{NAME} [SUBCOMMAND [options]]"
      opts.separator ""
      opts.separator <<-COMMANDS.gsub(/^ {8}/, "")
        build        :   build one or more templates
        build_remote :   build one or more templates via buildkite
        help         :   prints this help message
        list         :   list all templates in project
        normalize    :   normalize one or more templates
        test         :   test one or more builds with kitchen
        upload       :   upload one or more builds to Atlas and S3
        release      :   release a version of a box on Atlas
        revoke       :   revoke a version of a box on Atlas
        delete       :   delete a version of a box from Atlas
      COMMANDS
    end

    platforms_argv_proc = proc { |options|
      options.platforms = builds['public'] unless args.empty?
    }

    templates_argv_proc = proc { |options|
      options.templates = calculate_templates(args) unless args.empty?

      options.templates.each do |t|
        if !File.exists?("#{t}.json")
          $stderr.puts "File #{t}.json does not exist for template '#{t}'"
          exit(1)
        end
      end
    }

    box_version_argv_proc = proc { |options|
      options.box = ARGV[0]
      options.version = ARGV[1]
    }

    md_json_argv_proc = proc { |options|
      options.md_json = ARGV[0]
    }

    subcommand = {
      help: {
        parser: OptionParser.new {},
        argv: proc { |options|
          puts global
          exit(0)
        }
      },
      build: {
        class: BuildRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} build [options] TEMPLATE[ TEMPLATE ...]"

          opts.on("-n", "--dry-run", "Dry run (what would happen)") do |opt|
            options.dry_run = opt
          end

          opts.on("-d", "--[no-]debug", "Run packer with debug output") do |opt|
            options.debug = opt
          end

          opts.on("-o BUILDS", "--only BUILDS", "Only build some Packer builds") do |opt|
            options.builds = opt
          end

          opts.on("-e BUILDS", "--except BUILDS", "Build all Packer builds except these") do |opt|
            options.except = opt
          end

          opts.on("-m MIRROR", "--mirror MIRROR", "Look for isos at MIRROR") do |opt|
            options.mirror = opt
          end

          opts.on("-C cpus", "--cpus CPUS", "# of CPUs per provider") do |opt|
            options.cpus = opt
          end

          opts.on("-M MEMORY", "--memory MEMORY", "Memory (MB) per provider") do |opt|
            options.mem = opt
          end

          opts.on("-H", "--headed", "Display provider UI windows") do |opt|
            options.headed = opt
          end

          opts.on("-v VERSION", "--version VERSION", "Override the version set in the template") do |opt|
            options.override_version = opt
          end
        },
        argv: templates_argv_proc
      },
      build_remote: {
        class: BuildRemoteRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} build_remote [options] [PLATFORM ...]"

          opts.on("-v VERSION", "--version VERSION", "Override the version set in the template") do |opt|
            options.override_version = opt
          end

          opts.on("--dry-run", "Show me what you got") do |opt|
            options.dry_run = opt
          end
        },
        argv: platforms_argv_proc
      },
      list: {
        class: ListRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} list [TEMPLATE ...]"
        },
        argv: templates_argv_proc
      },
      normalize: {
        class: NormalizeRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} normalize TEMPLATE[ TEMPLATE ...]"

          opts.on("-d", "--[no-]debug", "Run packer with debug output") do |opt|
            options.debug = opt
          end
        },
        argv: templates_argv_proc
      },
      test: {
        class: TestRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} test [options]"

          opts.on("-f", "--shared-folder", "Enable shared folder") do |opt|
            options.shared_folder = opt
          end

          opts.on("-p", "--provisioner PROVISIONER", "Use a specfic provisioner") do |opt|
            options.provisioner = opt
          end
        },
        argv: Proc.new {}
      },
      upload: {
        class: UploadRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} upload"
        },
        argv: md_json_argv_proc
      },
      release: {
        class: ReleaseRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} release BOX VERSION"
        },
        argv: box_version_argv_proc
      },
      revoke: {
        class: RevokeRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} revoke BOX VERSION"
        },
        argv: box_version_argv_proc
      },
      delete: {
        class: DeleteRunner,
        parser: OptionParser.new { |opts|
          opts.banner = "Usage: #{NAME} delete BOX VERSION"
        },
        argv: box_version_argv_proc
      }
    }

    global.order!
    command = args.empty? ? :help : ARGV.shift.to_sym
    subcommand.fetch(command).fetch(:parser).order!
    subcommand.fetch(command).fetch(:argv).call(options)

    options.command = command
    options.klass = subcommand.fetch(command).fetch(:class)

    options
  end

  def self.calculate_templates(globs)
    Array(globs).
      map { |glob| result = Dir.glob(glob); result.empty? ? glob : result }.
      flatten.
      sort.
      delete_if { |file| file =~ /\.variables\./ }.
      map { |template| template.sub(/\.json$/, '') }
  end
end

class ListRunner

  include Common

  attr_reader :templates

  def initialize(opts)
    @templates = opts.templates
  end

  def start
    templates.each { |template| puts template }
  end
end

class Runner

  attr_reader :options

  def initialize(options)
    @options = options
  end

  def start
    options.klass.new(options).start
  end
end
