require 'bento/common'
require 'bento/httpstuff'

module VgCloud
  include Common
  include HttpStuff

  def vgc_api
    @vgc_api ||= 'https://vagrantcloud.com/api/v1'
  end

  def vgc_org
    @vgc_org ||= ENV['ATLAS_ORG']
  end

  def vgc_token
    @vgc_token ||= ENV['ATLAS_TOKEN']
  end

  def box_create(boxname)
    req = request('get', "#{vgc_api}/box/#{vgc_org}/#{boxname}", { 'box[username]' => vgc_org, 'access_token' => vgc_token } )
    if req.code.eql?('404')
      req = request('post', "#{vgc_api}/boxes", { 'box[name]' => boxname, 'box[username]' => vgc_org, 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' } )
      box_set_public(boxname) unless private_box?(boxname)
    else
      banner("The box #{boxname} exists in Atlas, continuing...")
    end
  end

  def box_create_providers(boxname, version, provider_names)
    provider_names.each do |provider|
      banner("Creating provider #{provider} for #{boxname} #{version}")
      req = request('post', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}/providers", { 'provider[name]' => provider, 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' }  )
      banner("Created #{provider} for #{boxname} #{version}") if req.code == '200'
      banner("Provider #{provider} for #{boxname} #{version} already exists, continuing.") if req.code == '422'
    end
  end

  def box_create_version(boxname, version, md_json)
    payload = {
      'version[version]' => version,
      'access_token' => vgc_token,
      'version[description]' => File.read(md_json)
    }
    req = request('post', "#{vgc_api}/box/#{vgc_org}/#{boxname}/versions", payload, { 'Content-Type' => 'application/json' } )

    banner("Created box version #{boxname} #{version}.") if req.code == '200'
    banner("Box version #{boxname} #{version} already exists, continuing.") if req.code == '422'
  end

  def box_delete_version(boxname, version)
    banner("Deleting version #{version} of box #{boxname}")
    req = request('delete', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}", { 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' })

    case req.code
    when '200'
      banner("Version #{version} of box #{boxname} has been successfully deleted")
    when '404'
      warn("No box exists for this version")
    else
      warn("Something went wrong #{req.code}")
    end
  end

  def box_release_version(boxname, version)
    case box_status(boxname, version)
    when 'unreleased'
      banner("Releasing version #{version} of box #{boxname}")
      req = request('put', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}/release", { 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' })
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

  def box_revoke_version(boxname, version)
    banner("Revoking version #{version} of box #{boxname}")
    req = request('put', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}/revoke", { 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' })
    if req.code == '200'
      banner("Version #{version} of box #{boxname} has been successfully revoked")
    else
      banner("Something went wrong #{req.code}")
    end
  end

  def box_status(boxname, version)
    req = request('get', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}", { 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' })
    status = JSON.parse(req.body)['status']
  end

  def box_set_public(boxname)
    banner("Making #{boxname} public")
    req = request('put', "#{vgc_api}/box/#{vgc_org}/#{boxname}", { 'box[is_private]' => false, 'access_token' => vgc_token }, { 'Content-Type' => 'application/json' } )
    banner("#{boxname} successfully made public") if req.code == '200'
  end

  def box_upload(md_file)
    md = box_metadata(md_file)
    boxname = md['name']
    version = md['version']
    providers = md['providers']

    box_create(boxname)
    box_create_version(boxname, version, md_file)
    box_create_providers(boxname, version, providers.keys)

    providers.each do |provider, provider_data|
      boxfile = provider_data['file']
      req = request('get', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}/provider/#{provider}/upload?access_token=#{vgc_token}")
      upload_path = JSON.parse(req.body)['upload_path']
      token = JSON.parse(req.body)['token']

      banner("Vagrant Cloud: Uploading #{boxfile}")
      info("Name: #{boxname}")
      info("Version: #{version}")
      info("Provider: #{provider}")

      upload_request = request('put', upload_path, File.open("builds/#{boxfile}"))

      req = request('get', "#{vgc_api}/box/#{vgc_org}/#{boxname}/version/#{version}/provider/#{provider}?access_token=#{vgc_token}")
      hosted_token = JSON.parse(req.body)['hosted_token']

      if token == hosted_token
        banner("Successful upload of box #{boxfile}")
      else
        banner("Failed upload due to non-matching tokens of box #{boxfile} to atlas box: #{boxname}, version: #{version}, provider: #{provider}")
        warn("Code: #{req.code}")
        warn("Body: #{req.body}")
      end
    end
  end
end
