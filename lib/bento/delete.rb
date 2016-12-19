require 'bento/common'
require 'bento/httpstuff'

class DeleteRunner
  include Common
  include HttpStuff

  attr_reader :boxname, :version

  def initialize(opts)
    @boxname = opts.box
    @version = opts.version
  end

  def start
    banner("Starting Delete...")
    time = Benchmark.measure do
      delete_version(boxname, version)
    end
    banner("Delete finished in #{duration(time.real)}.")
  end

  private

  def delete_version(boxname, version)
    banner("Deleting version #{version} of box #{boxname}")
    req = request('delete', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}", { 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' })

    case req.code
    when '200'
      banner("Version #{version} of box #{boxname} has been successfully deleted")
    when '404'
      warn("No box exists for this version")
    else
      warn("Something went wrong #{req.code}")
    end
  end
end