require 'bento/common'
require 'mixlib/shellout'

class ReleaseRunner
  include Common
  include HttpStuff

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Release...")
    time = Benchmark.measure do
      release_version(boxname, version)
    end
    banner("Release finished in #{duration(time.real)}.")
  end

  private

  def release_version(boxname, version)
    case status(boxname, version)
    when 'unreleased'
      banner("Releasing version #{version} of box #{boxname}")
      req = request('put', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}/release", { 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' })
      if req.code == '200'
        banner("Version #{version} of box #{boxname} has been successfully released")
      else
        warn("Something went wrong #{req.code}")
      end
    when 'active'
      banner("Version #{version} of box #{boxname} has already been released - nothing to do")
    else
      warn("Unexpected status retrieved from Atlas")
    end
  end

  def status(boxname, version)
    req = request('get', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}", { 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' })
    status = JSON.parse(req.body)['status']
  end
end