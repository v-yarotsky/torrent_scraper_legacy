class RPC
  
  attr_reader :url
  
  def initialize(url, backend)
    @url  = url
    @backend = backend.new(@url)
  end
  
  
end