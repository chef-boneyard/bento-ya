require 'benchmark'
require 'fileutils'
require 'json'
require 'tempfile'
require 'yaml'

MEGABYTE = 1024.0 * 1024.0

module Common

  def banner(msg)
    puts "==> #{msg}"
  end

  def info(msg)
    puts "    #{msg}"
  end

  def warn(msg)
    puts ">>> #{msg}"
  end

  def duration(total)
    total = 0 if total.nil?
    minutes = (total / 60).to_i
    seconds = (total - (minutes * 60))
    format("%dm%.2fs", minutes, seconds)
  end

  def box_metadata(metadata_file)
    metadata = Hash.new
    file = File.read(metadata_file)
    json = JSON.parse(file)

    # metadata needed for upload:  boxname, version, provider, box filename
    metadata['name'] = json['name']
    metadata['version'] = json['version']
    metadata['box_basename'] = json['box_basename']
    metadata['tool_versions'] = json['box_basename']
    metadata['providers'] = Hash.new
    json['providers'].each do |provider|
      metadata['providers'][provider['name']] = provider.reject { |k, _| k == 'name' }
    end
    metadata
  end

  def metadata_files
    @metadata_files ||= compute_metadata_files
  end

  def compute_metadata_files
    `ls builds/*.json`.split("\n")
  end

  def atlas_api
    @atlas_api ||= 'https://atlas.hashicorp.com/api/v1'
  end

  def atlas_org
    @atlas_org ||= ENV['ATLAS_ORG']
  end

  def atlas_token
    @atlas_token ||= ENV['ATLAS_TOKEN']
  end

  def bento_upload
    "1"
  end

  def bento_version
    @bento_version ||= ENV['BENTO_VERSION']
  end

  def cpus
    1
  end

  def memory
    1024
  end

  def builds
    YAML.load(File.read("builds.yml"))
  end

  def private_box?(boxname)
    proprietary_os_list = %w(macosx sles solaris windows)
    proprietary_os_list.any? { |p| boxname.include?(p) }
  end

  def tool_versions
    tool_versions = Hash.new
    path = File.join('/Applications/VMware\ Fusion.app/Contents/Library')
    fusion_cmd = File.join(path, "vmware-vmx -v")
    ver_hash = {
      packer: "packer --version",
      vagrant: "vagrant --version",
      parallels: "prlctl --version",
      virtualbox: "VBoxManage --version",
      vmware_fusion: fusion_cmd
    }
    ver_hash.each do |tool, command|
      cmd = Mixlib::ShellOut.new(command)
      cmd.run_command
      case tool
      when /parallels/
        ver = cmd.stdout.split(' ')[2]
        # hash = cmd.stdout.split(' ')[3]
        # ver = "#{semver} #{hash}"
      when /fusion/
        ver = cmd.stderr.split(' ')[5]
        # hash = cmd.stderr.split(' ')[6].gsub(/^build-/,'')
        # ver = "#{semver} \(#{hash}\)"
      when /vagrant/
        semver = cmd.stdout.split(' ')[1]
        ver = "#{semver}"
      when /virtualbox/
        ver = cmd.stdout.split('r')[0]
        # hash = cmd.stdout.split('r')[1].gsub(/\n/,'')
        # ver = "#{semver} \(#{hash}\)"
      else
        ver = cmd.stdout.split("\n")[0]
      end
      tool_versions[tool] = ver
    end
    tool_versions
  end
end

# module PackerExec

#   def for_packer_run_with(template)
#     Tempfile.open("#{template}-metadata.json") do |md_file|
#       Tempfile.open("#{template}-metadata-var-file") do |var_file|
#         write_box_metadata(template, md_file)
#         yield md_file, var_file
#       end
#     end
#   end

#   def write_box_metadata(template, io)
#     md = BuildMetadata.new(template, build_timestamp, override_version).read
#     io.write(JSON.pretty_generate(md))
#     io.close
#   end

#   # def write_var_file(template, md_file, io)
#   #   md = BuildMetadata.new(template, build_timestamp, override_version).read

#   #   io.write(JSON.pretty_generate({
#   #     box_basename:     md[:box_basename],
#   #     build_timestamp:  md[:build_timestamp],
#   #     git_revision:     md[:git_revision],
#   #     metadata:         md_file.path,
#   #     version:          md[:version],
#   #   }))
#   #   io.close
#   # end
# end
