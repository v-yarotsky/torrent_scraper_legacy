class RPC::TransmissionBackend < ActiveResource::Base
  self.site = '192.168.1.4:9091/transmission/rpc/'
  
end