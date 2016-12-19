require 'bento/common'
require 'mixlib/shellout'

class RevokeRunner
  include Common
  include HttpStuff

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Revoke...")
    time = Benchmark.measure do
      revoke_version(boxname, version)
    end
    banner("Revoke finished in #{duration(time.real)}.")
  end

  private

  def revoke_version(boxname, version)
    banner("Revoking version #{version} of box #{boxname}")
    req = request('put', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}/revoke", { 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' })
    if req.code == '200'
      banner("Version #{version} of box #{boxname} has been successfully revoked")
    else
      banner("Something went wrong #{req.code}")
    end
  end
end