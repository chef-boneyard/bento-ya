require "benchmark"
require "fileutils"
require "json"
require "tempfile"
require "yaml"
require "vagrant_cloud"

MEGABYTE = 1024.0 * 1024.0

module Common
  def vc_account
    VagrantCloud::Account.new(ENV["VAGRANT_CLOUD_ORG"], ENV["VAGRANT_CLOUD_TOKEN"])
  end

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
    metadata["name"] = json["name"]
    metadata["version"] = json["version"]
    metadata["box_basename"] = json["box_basename"]
    metadata["tools"] = json["tools"]
    metadata["providers"] = Hash.new
    json["providers"].each do |provider|
      metadata["providers"][provider["name"]] = provider.reject { |k, _| k == "name" }
    end
    metadata
  end

  def metadata_files
    @metadata_files ||= compute_metadata_files
  end

  def compute_metadata_files
    `ls builds/*.json`.split("\n")
  end

  def builds
    YAML.load(File.read("builds.yml"))
  end

  def private_box?(boxname)
    proprietary_os_list = %w{macosx sles solaris windows}
    proprietary_os_list.any? { |p| boxname.include?(p) }
  end

  def os_x?
    !!(RUBY_PLATFORM =~ /darwin/)
  end

  def unix?
    !windows?
  end

  def windows?
    !!(RUBY_PLATFORM =~ /mswin|mingw|windows/)
  end
end
