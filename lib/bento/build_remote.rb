require 'buildkit'

class BuildRemoteRunner
  include Common

  attr_reader :bento_version, :dry_run, :platforms, :queue, :token, :s3_endpoint, :s3_bucket

  def initialize(opts)
    @dry_run = opts.dry_run
    @bento_version = opts.override_version
    @platforms = opts.platforms
    @org = ENV['BUILDKITE_ORG']
    @queue = ENV['BUILDKITE_QUEUE']
    @token = ENV['BUILDKITE_TOKEN']
    @s3_endpoint ||= ENV['BENTO_S3_ENDPOINT'] # 'https://s3.amazonaws.com''
    @s3_bucket ||= ENV['BENTO_S3_BUCKET'] # 'opscode-vm-bento''
  end

  def start
    msg_pre = dry_run ? "DRY RUN: " : ""

    banner("#{msg_pre}Scheduling builds for Bento Version: #{bento_version}")
    time = Benchmark.measure do
      builds['public'].each do |platform, versions|
        versions.each do |version, archs|
          archs.each do |arch|
            builds['providers'].each do |provider|
              build(platform, version, arch, provider, bento_version, dry_run)
            end
          end
        end
      end
    end
    banner("#{msg_pre}Scheduling finished in #{duration(time.real)}.")
  end

  private

  def bk_uri
    "v1/organizations/#{org}"
  end

  def build(platform, version, arch, provider, bento_version, dry_run)
    plat =  platform.include?('omnios') ? "#{platform}-#{version}" : "#{platform}-#{version}-#{arch}"
    atlas_name = /(.*)64/.match(arch) ? plat.chomp("-#{arch}") : plat
    no_shared = builds['no_shared_folder'].include?("#{platform}-#{version}-#{arch}-#{provider}") || builds['no_shared_folder'].include?("#{platform}-#{version}-#{arch}-all")
    test_shared = no_shared ? "0" : "1"
    unless builds['broken'].include?("#{plat}-#{provider}") || builds['broken'].include?("#{plat}-all")
      build = {
        "commit"=> "HEAD",
        "branch"=> "master",
        "message"=> "#{plat}-#{provider}",
        "env"=> {
          "ATLAS_ORG" => atlas_org,
          "ATLAS_TOKEN" => atlas_token,
          "ATLAS_NAME" => atlas_name,
          "AWS_ACCESS_KEY_ID" => ENV['AWS_ACCESS_KEY_ID'],
          "AWS_SECRET_ACCESS_KEY" => ENV['AWS_SECRET_ACCESS_KEY'],
          "AWS_REGION" => 'us-east-1',
          "BENTO_TEST_SHARED_FOLDER" => test_shared,
          "BENTO_UPLOAD" => bento_upload,
          "BENTO_VERSION" => bento_version,
          "BENTO_S3_ENDPOINT" => s3_endpoint,
          "BENTO_S3_BUCKET" => s3_bucket,
          "BENTO_PROVIDERS" => provider,
          "PLATFORM" => plat,
        }
     }
     puts "  - #{plat}-#{provider}"
     client.post("/#{bk_uri}/projects/bento-#{provider.chomp('-iso')}/builds", build) unless dry_run
    end
  end

  def client
    Buildkit.new(token: token)
  end

  def create_project
    project = {
      "name"=> project,
      "repository"=>"git@github.com:chef/bento.git",
      "env"=>{"BUILDKITE_BIN_PATH" => "/usr/local/opt/buildkite-agent/bin"},
      "steps"=>
      [{"type"=>"script",
        "name"=>"build",
        "command"=>"build.sh",
        "agent_query_rules"=>["queue=#{queue}"]
       }
      ]
    }

    puts "Creating Project #{project['name']}"
    client.post("/#{bk_uri}/projects", project)
  end

  def delete_project
    banner("Deleting Project #{project['name']}")
    client.delete("/#{bk_uri}/projects/#{project}")
  end

  def get_builders(provider)
    organization = client.organization(org)
    agents = organization.rels[:agents].get.data

    banner("Available Builders for provider: #{provider}")
    agents.each do |agent|
      if agent[:meta_data].include? "#{provider.chomp('-iso')}=true"
        puts "  - #{agent[:name]}"
      end
    end
  end
end