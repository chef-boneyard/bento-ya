require "net/http"

module HttpStuff

  def class_for_request(verb)
    Net::HTTP.const_get(verb.to_s.capitalize)
  end

  def build_uri(verb, path, params = {})
    if %w{delete, get}.include?(verb)
      path = [path, to_query_string(params)].compact.join("?")
    end

    # Parse the URI
    uri = URI.parse(path)

    # Don't merge absolute URLs
    uri = URI.parse(File.join(endpoint, path)) unless uri.absolute?

    # Return the URI object
    uri
  end

  def to_query_string(hash)
    hash.map do |key, value|
      "#{CGI.escape(key)}=#{CGI.escape(value)}"
    end.join("&")[/.+/]
  end

  def request(verb, url, data = {}, headers = {})
    uri = build_uri(verb, url, data)

    # Build the request.
    request = class_for_request(verb).new(uri.request_uri)
    if %w{patch post put delete}.include?(verb)
      if data.respond_to?(:read)
        request.content_length = data.size
        request.body_stream = data
      elsif data.is_a?(Hash)
        request.form_data = data
      else
        request.body = data
      end
    end

    # Add headers
    headers.each do |key, value|
      request.add_field(key, value)
    end

    connection = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == "https"
      require "net/https" unless defined?(Net::HTTPS)

      # Turn on SSL
      connection.use_ssl = true
      connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    end

    connection.start do |http|
      response = http.request(request)

      case response
      when Net::HTTPRedirection
        redirect = URI.parse(response["location"])
        request(verb, redirect, data, headers)
      else
        response
      end
    end
  end
end
