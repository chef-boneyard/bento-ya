require 'bento/common'
require 'bento/vagrantcloud'

class DeleteRunner
  include Common
  include VgCloud

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Delete...")
    time = Benchmark.measure do
      box_delete_version(boxname, version)
    end
    banner("Delete finished in #{duration(time.real)}.")
  end
end
