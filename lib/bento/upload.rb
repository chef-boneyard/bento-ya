require 'aws-sdk'
require 'bento/common'

class UploadRunner
  include Common
  include HttpStuff

  attr_reader :templates

  def initialize(opts)
    @templates = opts.templates
  end

  def start
    banner("Starting uploads...")
    time = Benchmark.measure do
      metadata_files.each do |file|
        md = box_metadata(file)
        create_box(md['name'])
        create_box_version(md['name'], md['version'], file)
        create_providers(md['name'], md['version'], md['providers'].keys)
        upload_to_atlas(md['name'], md['version'], md['providers'])
        #upload_to_s3(md['name'], md['version'], md['providers'])
      end
    end
    banner("Atlas uploads finished in #{duration(time.real)}.")
  end

  private

  def create_box(boxname)
    req = request('get', "#{atlas_api}/box/#{atlas_org}/#{boxname}", { 'box[username]' => atlas_org, 'access_token' => atlas_token } )
    if req.code.eql?('404')
      if private_box?(boxname)
        banner("Creating the private box #{boxname} in Atlas.")
        req = request('post', "#{atlas_api}/boxes", { 'box[name]' => boxname, 'box[username]' => atlas_org, 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' } )
      else
        banner("Creating the box #{boxname} in Atlas.")
        req = request('post', "#{atlas_api}/boxes", { 'box[name]' => boxname, 'box[username]' => atlas_org, 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' } )
        make_public(boxname)
      end
    else
      banner("The box #{boxname} exists in Atlas, continuing...")
    end
  end

  def make_public(boxname)
    banner("Making #{boxname} public")
    req = request('put', "#{atlas_api}/box/#{atlas_org}/#{boxname}", { 'box[is_private]' => false, 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' } )
    banner("#{boxname} successfully made public") if req.code == '200'
  end

  def create_box_version(boxname, version, md_json)
		payload = { 
	  	'version[version]' => version,
	  	'access_token' => atlas_token,
		'version[description]' => File.read(md_json)
		}
    req = request('post', "#{atlas_api}/box/#{atlas_org}/#{boxname}/versions", payload, { 'Content-Type' => 'application/json' } ) 

    banner("Created box version #{boxname} #{version}.") if req.code == '200'
    banner("Box version #{boxname} #{version} already exists, continuing.") if req.code == '422'
  end

  def create_providers(boxname, version, provider_names)
    provider_names.each do |provider|
      banner("Creating provider #{provider} for #{boxname} #{version}")
      req = request('post', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}/providers", { 'provider[name]' => provider, 'access_token' => atlas_token }, { 'Content-Type' => 'application/json' }  )
      banner("Created #{provider} for #{boxname} #{version}") if req.code == '200'
      banner("Provider #{provider} for #{boxname} #{version} already exists, continuing.") if req.code == '422'
    end
  end

  def upload_to_atlas(boxname, version, providers)
    providers.each do |provider, provider_data|
      boxfile = provider_data['file']
      req = request('get', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}/provider/#{provider}/upload?access_token=#{atlas_token}")
      upload_path = JSON.parse(req.body)['upload_path']
      token = JSON.parse(req.body)['token']

      banner("Atlas: Uploading #{boxfile}")
      info("Name: #{boxname}")
      info("Version: #{version}")
      info("Provider: #{provider}")
      info("Upload Path: #{upload_path}")
      upload_request = request('put', upload_path, File.open("builds/#{boxfile}"))

      req = request('get', "#{atlas_api}/box/#{atlas_org}/#{boxname}/version/#{version}/provider/#{provider}?access_token=#{atlas_token}")
      hosted_token = JSON.parse(req.body)['hosted_token']

      if token == hosted_token
        banner("Successful upload of box #{boxfile}")
      else
        banner("Failed upload due to non-matching tokens of box #{boxfile} to atlas box: #{boxname}, version: #{version}, provider: #{provider}")
        warn("Code: #{req.code}")
        warn("Body: #{req.body}")
      end
    end

    def upload_to_s3(boxname, version, providers)
      providers.each do |provider, provider_data|
        boxfile = provider_data['file']
        provider = 'vmware' if provider == 'vmware_desktop'
        box_path = "vagrant/#{provider}/opscode_#{boxname}_chef-provisionerless.box"
        credentials = Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])

        s3 = Aws::S3::Resource.new(credentials: credentials, endpoint: s3_endpoint)
        banner("S3: Uploading #{boxfile}")
        info("Name: #{boxname}")
        info("Version: #{version}")
        info("Provider: #{provider}")
        s3_object = s3.bucket(s3_bucket).object(box_path)
        s3_object.upload_file("builds/#{boxfile}", acl:'public-read')
        banner("Upload Path: #{s3_object.public_url}")
      end
    end
  end
end
