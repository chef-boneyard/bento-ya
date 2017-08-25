require "bento/common"

class UploadRunner
  include Common

  attr_reader :md_json

  def initialize(opts)
    @md_json = opts.md_json
  end

  def start
    banner("Starting uploads...")
    time = Benchmark.measure do
      files = md_json ? [md_json] : metadata_files
      files.each do |md_file|
        upload(md_file)
      end
    end
    banner("Uploads finished in #{duration(time.real)}.")
  end

  def upload(md_file)
    md = box_metadata(md_file)
    box_description = "a bento box for #{md['name']}"
    box = vc_account.ensure_box(md["name"], box_description, private_box?(md["name"]))
    version = box.ensure_version(md["version"], File.read(md_file))

    md["providers"].each do |k, v|
      provider = version.ensure_provider(k, nil)
      banner("Uploading #{box.name}/#{version.version}/#{provider.name}...")
      provider.upload_file("builds/#{v['file']}")
      banner("#{provider.download_url}")
    end
  end
end
