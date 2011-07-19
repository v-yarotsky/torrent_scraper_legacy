module RPC
  module Transmission
    class Connection < ConnectionBase
      def initialize(*args)
        @session_id = ""
        super
      end
  
      def set_request_headers(request)
        request['Content-Type']= 'application/json'
        request['X-Transmission-Session-Id'] = @session_id
      end
  
      def handle_response(response)
        if response.code == "409"
          log "Setting session id to #{response["x-transmission-session-id"]}\nWas #{@session_id}"
          @session_id = response["x-transmission-session-id"]
          send_request
        else
          super
        end
      end
    end
   
    class Command < CommandBase
     def initialize(method, arguments = nil)
       @method = method
       @arguments = arguments
       super
     end

     def to_json
       result = { "method" => @method.to_s } 
       if @arguments
         @arguments.reject! { |k,v| v.nil? }
         result.merge!({ "arguments" => @arguments })
       end
       result.to_json
     end
    end

    class Backend < BackendBase
       def initialize(*args)
       @connection = Connection.new(*args)
     end

     def add_torrent(torrent)
       execute Command.new("torrent-add", "metainfo" => torrent)
     end

     def remove_torrent(ids, delete_data = false)
       execute Command.new("torrent-remove", "ids" => ids, "delete-local-data" => delete_data)
     end

     def update_torrent(ids, files, priority)
       execute Command.new("torrent-set", "ids" => ids, "bandwidthPriority" => priority, "files-wanted" => files)
     end

     def torrent_info(ids = nil)
       execute Command.new("torrent-get", "ids" => ids, "fields" => ["bandwidthPriority", "errorString", "files", "id", "isFinished", "name", "peersConnected", "peersGettingFromUs", "peersSendingToUs", "percentDone", "status", "totalSize", "torrentFile"])
     end

     def start_torrent(ids = nil)
       execute Command.new("torrent-start", "ids" => ids)
     end

     def stop_torrent(ids = nil)
       execute Command.new("torrent-stop", "ids" => ids)
     end

     def download_speed
       execute Command.new("session-stats")
     end

     def upload_speed
       execute Command.new("session-stats")
     end

     def slow_mode?
       execute Command.new("session-get")
     end

     def downloads_dir
       execute Command.new("session-get")
     end

     def free_space
       execute Command.new("session-get")
     end

     private

     def execute(command)
       @connection.send_request(command)
     end
 
     def process_result(result)
       JSON.parse(result)
     end
    end
  end
end