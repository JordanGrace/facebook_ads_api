module FacebookAdsApi
  ##
  # Client: This class contains all the necessary logic to handle the communication to
  # Facebook's Graph API.  Currently the Client class requires you to pass an access
  # token obtained from facebook.  An Oauth authentication solution is not currently
  # implemented.
  class Client
    include Utils

    ##
    # DEFAULTS: Setting a default configuration.  By default facebook graph api will be
    # defaulted to the latest version availble at the team of a version release.  Also SSL
    # will always be used, in fact it is kind of pointless to make in an overridable option
    # because facebook requires you to use https when sending access_tokens.
    #
    # todos: Change ssl_verify_peer back to true and include cacert.pem.
    DEFAULTS = {
      host: "graph.facebook.com",
      api_version: "v2.4",
      port: 443,
      use_ssl: true,
      ssl_verify_peer: false,
      ssl_ca_file: nil,
      timeout: 30,
      proxy_address: nil,
      proxy_user: nil,
      proxy_password: nil,
      retries: 1
    }

    ##
    # Defining readonly attributes.
    attr_reader :access_token, :accounts

    ##
    # intitalize: Accepts an non-optional access_token and a optional options hash.
    # There are currently no stratgies for handling OAuth communication, between
    # the gem and facebook, that are implemented.  access_token will need to be
    # retrieved outside of the gem in the users implementation. The method
    # creates @access_token and @config instance variables and calls
    # setup_connection and setup_resource methods to create an instance of Net::HTTP
    # and instance of the Accounts class.
    def initialize(access_token, options={})
      @access_token = access_token.strip
      @config = DEFAULTS.merge! options

      setup_connection
      setup_resources
    end

    ##
    # inspect: Using a custom inspect method. This might disappear in the future.
    def inspect
      "<FacebookAdsApi::Client @access_token=#{@access_token}>"
    end

    ##
    # Dynamically define methods for types of HTTP requests.  Currently only :get
    # requests are implemented and other requests will be added as functionality is completed.
    # Each type of HTTP request is uses the same logic below.
    [:get].each do |method|
      # Is method actually a method of Net::HTTP? If no this will throw an exception.
      method_class = Net::HTTP.const_get method.to_s.capitalize

      # Defining each method with path and params parameters.
      define_method method do |path, params|
        params = {} if params.empty?

        # Add access_token obtained from facebook to path.
        path << "?access_token=#{@access_token}"

        # Use url_encode Utils method to convert parameters into something the request
        # can append to path.
        path << "&#{url_encode(params)}" unless params.empty?

        # Created a new Net::HTTP Get request.
        request = method_class.new path

        # Call send_request and pass request.  send_request will preform the request and process
        # the response.
        send_request request
      end
    end

    private

    ##
    # setup_connection: Setup a new Net::HTTP connection and assigns it to the
    # @connection instance variable.
    def setup_connection
      # Incase a proxy is desired.
      connection = Net::HTTP::Proxy @config[:proxy_addess], @config[:proxy_port],
        @config[:proxy_user], @config[:proxy_address]

      # Create a new connection with graph.facebook.com host.
      @connection = connection.new @config[:host], @config[:port]

      # Call setup_ssl if use_ssl is set to true in @config.  This will
      # basically always need to be true because facebook does not allow
      # transmission of access_tokens with out the use of HTTPS.
      setup_ssl if @config[:use_ssl]

      @connection.open_timeout = @config[:timeout]
      @connection.read_timeout = @config[:timeout]
    end

    ##
    # setup_ssl: configure Net::HTTP to use ssl and how to handle ssl_verify_peer settings.
    def setup_ssl
      @connection.use_ssl = @config[:use_ssl]

      if @config[:ssl_verify_peer]
        @connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
        @connection.ca_file = @config[:ssl_ca_file]
      else
        @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    ##
    # setup_resources: Initializes the resources to start using the gem.  This method
    # creates the @accounts instance variable with a new instance of Accounts.
    def setup_resources
      @accounts = Accounts.new "/#{@config[:api_version]}", self
    end

    ##
    # send_request: Accpets a non optional request object.  Performs the desired HTTP request
    # and returns a response.
    def send_request(request)
      @previous_request = request
      retries_remaining = @config[:retries]

      begin
        response = @connection.request request
        @previous_response = response

        if response.kind_of? Net::HTTPServerError
          object = parse_response response
          raise FacebookAdsApi::ServerError.new object['error']['message'], object['error']['code']
        end
      rescue Exception
        raise if request.class == Net::HTTP::Post
        if retries_remaining > 0 then retries_remaining -= 1; retry else raise end
      end

      object = parse_response(response)

      if response.kind_of? Net::HTTPClientError
        raise FacebookAdsApi::RequestError.new object['error']['message'], object['error']['code']
      end

      object
    end

    ##
    # parse_response: Accepts a non-optional response and uses MultiJson to
    # unpack it into a useable hash.
    def parse_response(response)
      object = nil

      if response.body and !response.body.empty?
        object = MultiJson.load response.body
      end

      object
    end
  end
end