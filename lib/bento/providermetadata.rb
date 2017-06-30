require 'digest'

class ProviderMetadata

  def initialize(path, box_basename)
    @base = File.join(path, box_basename)
  end

  def read
    Dir.glob("#{base}.*.box").map do |file|
      {
        name: provider_from_file(file),
        version: version(provider_from_file(file)),
        file: "#{File.basename(file)}",
        checksum_type: "sha256",
        checksum: shasum(file),
        size: "#{size_in_mb(file)} MB",
      }
    end
  end

  private

  attr_reader :base

  def provider_from_file(file)
    file.sub(/^.*\.([^.]+)\.box$/, '\1')
  end

  def shasum(file)
    Digest::SHA256.file(file).hexdigest
  end

  def size_in_mb(file)
    size = File.size(file)
    size_mb = size /  MEGABYTE
    size_mb.ceil.to_s
  end

  def version(provider)
    case provider
    when /vmware/
      ver_fusion
    when /virtualbox/
      ver_vbox
    when /parallels/
      ver_parallels
    end
  end

  def ver_fusion
    path = File.join('/Applications/VMware\ Fusion.app/Contents/Library')
    fusion_cmd = File.join(path, "vmware-vmx -v")
    cmd = Mixlib::ShellOut.new(fusion_cmd)
    cmd.run_command
    cmd.stderr.split(' ')[5]
  end

  def ver_parallels
    cmd = Mixlib::ShellOut.new("prlctl --version")
    cmd.run_command
    cmd.stdout.split(' ')[2]
  end

  def ver_vbox
    cmd = Mixlib::ShellOut.new("VBoxManage --version")
    cmd.run_command
    cmd.stdout.split('r')[0]
  end
end
