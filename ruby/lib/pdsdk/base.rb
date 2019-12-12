require "pdsdk/version"
require "pdsdk/logger"
require "json"
require 'concurrent'

module Pdsdk
  class Error < StandardError
  end

  # TODO share these strings in some json config file across all SDKs?
  ENV_KEY_PREFIX = "PD_"
  ENV_SECRET_KEY_KEY = "#{ENV_KEY_PREFIX}SECRET_KEY"

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def logger=(v)
      @logger = v
    end

    def bootstrap!
      logger.info "bootstrapping..."

      @secret_key = ENV[ENV_SECRET_KEY_KEY]
      if !@secret_key
        logger.warn "no $#{ENV_SECRET_KEY_KEY} detected, will not sign payloads"
      end
    end

    def log(api_key, message)
      puts "[#{Thread.current.object_id}] #{Time.now}  (#{api_key}) #{message}"
    end

    # XXX self.send_message for string and becomes { message } ?
    def send_event(api_key, raw_event, opts={}, include_response = false)
      hostname = ENV["PD_SDK_HOST"] || "sdk.m.pipedream.net"
      proto = ENV["PD_SDK_PROTO"] || "https"
      event = opts[:exports] || {}
      event[:raw_event] = raw_event
      if opts[:deployment]
        _uri = "#{proto}://#{hostname}/pipelines/#{api_key}/deployments/#{opts[:deployment]}/events"
      else
        _uri = "#{proto}://#{hostname}/pipelines/#{api_key}/events"
      end
      log(api_key, "Creating URI #{_uri}")
      uri = URI(_uri)
      log(api_key, "Done creating URI #{_uri}")
      use_ssl = uri.scheme == "https"
      # TODO clean up old connections
      # TODO ensure reconnects if client disconnects
      log(api_key, "Conditional create @https, #{@https}")
      @https ||= Concurrent::ThreadLocalVar.new { {} }
      log(api_key, "Conditional create http, #{@https.value[_uri]}")
      http = @https.value[_uri] ||= Net::HTTP.start(uri.host, uri.port, { use_ssl: use_ssl, open_timeout: 1 })
      log(api_key, "Current http, #{@https.value[_uri]}")
      log(api_key, "going to send event: #{event}")
      logger.info "going to send event: #{event}" # TODO remove
      log(api_key, "creating payload from event.json")
      payload = event.to_json
      headers = {
        "user-agent" => "pipedream-sdk:ruby/1",
        "content-type" => "application/json",
        "accept" => "application/json",
        "x-pd-sdk-version" => Pdsdk::VERSION,
      }
      log(api_key, "creating headers")
      headers["x-pd-sig"] = "sha256=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret_key, payload)}" if @secret_key
      log(api_key, "creating request")
      req = Net::HTTP::Post.new(uri.request_uri, headers)
      log(api_key, "setting request.body from payload")
      req.body = payload
      log(api_key, "sending request")
      resp = http.request(req)
      log(api_key, "received response: #{resp}")
      logger.info "received response: #{resp}" # TODO remove
      if include_response
        log(api_key, "include response = true")
        { 'code' => resp.code.to_i, 'body' => resp.body }
      else
        log(api_key, "include response = false")
        { 'code' => resp.code.to_i }
      end
    end

    def load_metadata(metadata_path, merge_data)
      metadata = {}
      begin
        metadata = JSON.parse(File.read(metadata_path))
      rescue
        # assume the service is not METADATA'ed, hence LOCAL development
        branch = `git rev-parse --abbrev-ref HEAD`.strip rescue nil
        metadata[:branch] = branch if !branch.blank?
        git_ref = `git rev-parse HEAD`.strip rescue nil
        metadata[:git_ref] = git_ref if !git_ref.blank?
      end
      metadata[:pdsdk_version] = Pdsdk::VERSION
      metadata[:started_at] = Time.now.to_f
      metadata[:name] = ENV["PD_METADATA_NAME"] || `hostname`.strip
      metadata.merge!(merge_data) # XXX deep?
      metadata
    end
  end
end

Pdsdk.bootstrap!
