module FacebookAdsApi
	##
	# GraphObject: This class services as the basis for communicating and maniuplating
	# a singular Facebook resource such as Account or Ad.  
	class GraphObject
    include Utils

    ##
    # initialize: Accepts a non optional path(String) and client(Client Object).
    # Also accpets a option params (Hash) which contains parameters obtained from Facebook's
    # API. setup_properties is called during initilization.
    def initialize(path, client, params={})
      @path, @client = path, client
      setup_properties params
    end

    ##
    # inspect: Using a custom inspect method. This might disappear in the future.
    def inspect
      "<#{self.class} @path=#{@path}>"
    end

    ##
    # to_hash: Gathers all the singleton methods that are created by setup_properties
    # and creates a hash representation.
    def to_hash
      hash = {}

      self.singleton_methods.each do |method|
        hash[method] = self.send method
      end

      hash
    end

    protected

    ##
    # resource: 
    def resource(*resources)
      resources.each do |r|
        resource = resourceify r
        path = "#{@path}/#{resource.downcase}"
        enclosed_module = @sub_module == nil ? (FacebookAdsApi) : (FacebookAdsApi.const_get(@sub_module))
        resource_class = enclosed_module.const_get resource
        instance_variable_set("@#{r}", resource_class.new(path, @client))
      end

      self.class.instance_eval { attr_reader *resources }
    end

    ##
    #
    def setup_properties(hash)
      tmpclass = class << self; self; end

      hash.each do |key,val|
        tmpclass.send :define_method, key.to_sym, &lambda {val}
      end
    end
  end
end