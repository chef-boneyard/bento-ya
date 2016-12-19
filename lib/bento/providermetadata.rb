require 'digest'

class ProviderMetadata

  def initialize(path, box_basename)
    @base = File.join(path, box_basename)
  end

  def read
    Dir.glob("#{base}.*.box").map do |file|
      {
        name: provider_from_file(file),
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
    case provider = file.sub(/^.*\.([^.]+)\.box$/, '\1')
    when /vmware/i then "vmware_desktop"
    else provider
    end
  end

  def shasum(file)
    Digest::SHA256.file(file).hexdigest
  end

  def size_in_mb(file)
    size = File.size(file)
    size_mb = size /  MEGABYTE
    size_mb.ceil.to_s
  end
end