module FacebookAdsApi
  ##
  #
  class GraphObjects
    ##
    #
    def initialize(path, client, params={})
      @path, @client = path, client
      resource_name = self.class.name.split('::')[-1]
      instance_name = resource_name.chop
  
      parent_module = self.class.to_s.split('::')[-2]
      full_module_path = parent_module == "FacebookAdsApi" ? (FacebookAdsApi) : (FacebookAdsApi.const_get parent_module)

      @instance_class = full_module_path.const_get instance_name
    end

    ##
    #
    def list(params={})
      raise "Can't list a Graph Object with out a client" unless @client
      response = @client.get @path, params
      resources = response["data"]

      resource_list = resources.map do |resource|
        @instance_class.new "#{@path.split('?').first}/#{resource['adgroup_id']}", @client, resource
      end

      resource_list
    end

    ##
    #
    def get(id)
      instance = @instance_class.new "#{@path}/#{id}", @client
    end

    ##
    #
    def inspect
      "<#{self.class} @path=#{@path}>"
    end
  end

  class GraphObject
    include Utils

    ##
    #
    def initialize(path, client, params={})
      @path, @client = path, client
      setup_properties params
    end

    ##
    #
    def inspect
      "<#{self.class} @path=#{@path}>"
    end

    def to_hash
      hash = {}

      self.singleton_methods.each do |method|
        hash[method] = self.send method
      end

      hash
    end

    protected

    ##
    #
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