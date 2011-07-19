require 'net/http'
require 'uri'
require 'json'

module RPC
  class AuthenticationError < Exception; end

  class UnknownResponse < Exception
    def initialize(response)
      super("Don't know how to process response##{response.code}")
    end
  end

  class RPC
    class << self
      attr_accessor :backend
    end
  end
  
  class ConnectionBase
    def initialize(uri, options = {})
      @uri = uri
      @options = options
    end

    def send_request(command = nil)
      command ||= @last_command
      @last_command = command
      Net::HTTP.start(@uri.host, @uri.port) do |http|
        request = build_request command
        response = http.request request
        handle_response(response)
      end
    end

    protected

    def build_request(data)
      request = Net::HTTP::Post.new(@uri.request_uri)
      log data.to_json
      request.body = data.to_json
      authenticate(request)
      set_request_headers(request)
      request
    end

    def authenticate(request)
      if @options[:username] && @options[:password]
        request.basic_auth @options[:username], @options[:password]
      end
    end

    def set_request_headers(request)
      request['Content-Type']= 'application/json'
    end

    def handle_response(response)
      case response.code
      when "200"
        log("Success"); puts response.body; process_result(response.body)
      when "401"
        raise AuthenticationError.new("Not authorized. Check credentials.")
      else
        raise UnknownResponse.new(response)
      end
    end

    def log(message)
      Rails.logger.debug "%s: %s" % [self.class.name, message]
    end

  end

  class CommandBase
    def to_json
    end
  end
  
  class BackendBase
    def add_torrent(torrent)
    end
    
    def remove_torrent(ids, delete_data = false)
    end
    
    def update_torrent(ids, priority, files)
    end
    
    def torrent_info(ids = nil)
    end
    
    def start_torrent(ids = nil)
    end
    
    def stop_torrent(ids = nil)
    end
    
    def download_speed
    end
    
    def upload_speed
    end
    
    def downloads_dir
    end
    
    def free_space
    end
    
    def slow_mode?
    end
  end
end
