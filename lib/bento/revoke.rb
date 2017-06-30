require 'bento/common'
require 'bento/vagrantcloud'

class RevokeRunner
  include Common
  include VgCloud

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Revoke...")
    time = Benchmark.measure do
      box_revoke_version(boxname, version)
    end
    banner("Revoke finished in #{duration(time.real)}.")
  end
end
