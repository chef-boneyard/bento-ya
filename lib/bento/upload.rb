require "bento/common"
require 'json'

class UploadRunner
  include Common

  attr_reader :md_json

  def initialize(opts)
    @md_json = opts.md_json
  end

  def start
    banner("Starting uploads...")
    time = Benchmark.measure do
      files = md_json ? [md_json] : metadata_files
      files.each do |md_file|
        upload(md_file)
      end
    end
    banner("Uploads finished in #{duration(time.real)}.")
  end

  def box_cmd(action, md)
    box_create_cmd = "vagrant cloud box #{action} bento/#{md['name']} -s 'A minimal test box for #{md['name']} created with Bento by Chef'"
    cmd = Mixlib::ShellOut.new(box_create_cmd)
    cmd.run_command
    cmd
  end

  def version_cmd(action, md)
    version_create_cmd = "vagrant cloud version #{action} bento/#{md['name']} #{md["version"]} -d 'A minimal test box for #{md['name']} created with Bento by Chef'"
    cmd = Mixlib::ShellOut.new(version_create_cmd)
    cmd.run_command
    cmd
  end

  def upload_necessary?(boxname, version, provider)
    begin
      search_output = JSON.parse(Mixlib::ShellOut.new("vagrant cloud search bento/#{boxname} --json").run_command.stdout)
    rescue JSON::ParserError => e
      if e.to_s.match?(/No results found/)
        return true # new box that's never been published
      else
        raise e
      end
    end

    box_entry = search_output.select{|entry| entry['name'] == "bento/#{boxname}" } # grab the exact box vs. fuzzy search results we get back

    return true unless box_entry[0]['version'] == version
    return true unless box_entry[0]['providers'].include?(provider)
    return false
  end

  def upload(md_file)
    banner "Attempting to upload #{md_file}"
    md = box_metadata(md_file)

    box_cmd('update', md) if box_cmd('create', md).stderr.match?(/has already been taken/)
    banner "bento/#{md['name']} box entry created"

    version_cmd('update', md) if version_cmd('create', md).stderr.match?(/has already been taken/)
    banner "bento/#{md['name']} version entry #{md["version"]} created"

    #
    # if builds_yml["slugs"].value?(box.name)
    #   slug_desc = "A Bento box for #{builds_yml['slugs'].key(box.name)}"
    #   slug = vc_account.ensure_box(builds_yml["slugs"].key(box.name), {short_description: slug_desc, is_private: false})
    #   slug_ver = slug.ensure_version(md["version"], File.read(md_file))
    # end

    md["providers"].each do |k, v|
      upload_necessary?(md['name'], md['version'], k)

      banner("Starting upload of bento/#{md['name']} #{md['version']} #{k} from builds/#{v['file']}. This will take a while...")
      upload = Mixlib::ShellOut.new("vagrant cloud publish bento/#{md['name']} #{md['version']} #{k} builds/#{v['file']} -fr").run_command
      require 'pry'; binding.pry
      #
      # next unless builds_yml["slugs"].value?(box.name)
      #
      # slug_provider = slug_ver.ensure_provider(k, nil)
      # banner("Uploading #{slug.name}/#{slug_ver.version}/#{slug_provider.name}...")
      # slug_provider.upload_file("builds/#{v['file']}")
      # banner(slug_provider.download_url.to_s)
    end
  end
end
