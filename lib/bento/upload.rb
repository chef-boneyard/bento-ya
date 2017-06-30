require 'bento/common'
require 'bento/vagrantcloud'

class UploadRunner
  include Common
  include VgCloud

  attr_reader :md_json

  def initialize(opts)
    @md_json = opts.md_json
  end

  def start
    banner("Starting uploads...")
    time = Benchmark.measure do
      if md_json.nil?
        metadata_files.each do |md_file|
          box_upload(md_file)
        end
      else
        box_upload(md_json)
      end
    end
    banner("Atlas uploads finished in #{duration(time.real)}.")
  end
end
