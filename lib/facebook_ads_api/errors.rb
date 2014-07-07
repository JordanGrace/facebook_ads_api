module FacebookAdsApi
  ##
  # ServerError: This class is used to return useful error messages 
  # due to server faults.
  class ServerError < StandardError
    attr_reader :code

    def initialize(message, code=nil)
      super message
      @code = code
    end
  end

  ##
  # RequestError: This class is isued to return useful error messages
  # due to errors returned from Facebooks API;
  class RequestError < StandardError
    attr_reader :code

    def initialize(message, code=nil)
      super message
      @code = code
    end
  end
end