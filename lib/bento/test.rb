require 'bento/common'
require 'kitchen'

class TestRunner
  include Common

  attr_reader :shared_folder, :boxname, :provider, :box_url, :share_disabled, :provisioner

  def initialize(opts)
    @debug = opts.debug
    @shared_folder = opts.shared_folder
    @provisioner = opts.provisioner.nil? ? "shell" : opts.provisioner
  end

  def start
    banner("Starting testing...")
    time = Benchmark.measure do
      metadata_files.each do |metadata_file|
        m = box_metadata(metadata_file)
        destroy_all_bento
        test_box(m['name'], m['providers'])
        destroy_all_bento
      end
    end
    banner("Testing finished in #{duration(time.real)}.")
  end

  private

  def destroy_all_bento
    cmd = Mixlib::ShellOut.new("vagrant box list | grep 'bento-'")
    cmd.run_command
    boxes = cmd.stdout.split("\n")

    boxes.each do |box|
      b = box.split(' ')
      rm_cmd = Mixlib::ShellOut.new("vagrant box remove --force #{b[0]} --provider #{b[1].to_s.gsub(/(,|\()/, '')}")
      banner("Removing #{b[0]} for provider #{b[1].to_s.gsub(/(,|\()/, '')}")
      rm_cmd.run_command
    end
  end

  def test_box(boxname, providers)
    providers.each do |provider, provider_data|

      if provider == 'vmware_desktop'
        case RUBY_PLATFORM
        when /darwin/
          provider = 'vmware_fusion'
        when /linux/
          provider = 'vmware_workstation'
        end
      end

      @boxname = boxname
      @provider = provider
      @share_disabled = shared_folder ? false : true
      @box_url = "file://#{ENV['PWD']}/builds/#{provider_data['file']}"

      kitchen_cfg = ERB.new(File.read('.kitchen.yml.erb'), nil, '-').result(binding)
      File.open(".kitchen.#{provider}.yml", "w") { |f| f.puts kitchen_cfg }

      Kitchen.logger = Kitchen.default_file_logger
      @loader = Kitchen::Loader::YAML.new(project_config: "./.kitchen.#{provider}.yml")
      config = Kitchen::Config.new(loader: @loader)
      config.instances.each do |instance|
        instance.test(:always)
      end
    end
  end
end