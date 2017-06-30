require 'bento/common'
require 'bento/vagrantcloud'

class ReleaseRunner
  include Common
  include VgCloud

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Release...")
    time = Benchmark.measure do
      box_release_version(boxname, version)
    end
    banner("Release finished in #{duration(time.real)}.")
  end
end
