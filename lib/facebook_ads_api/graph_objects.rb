module FacebookAdsApi
  ##
  #
  class GraphObjects
    include Utils

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

      client, list_class = @client, self.class
      resource_list.instance_eval do 
        tmpclass = class << self; include Utils; self; end

        tmpclass.send :define_method, :next_page, &lambda{
          if response.has_key?("paging") and response["paging"].has_key?("next")
            page_path = response["paging"]["next"].split("?").first
            page_params = url_unpack(response["paging"]["next"].split("?").last).delete_if{ |k,v| k.eql?(:access_token) }

            list_class.new(page_path,client).list(page_params)
          else
            []
          end
        }

        tmpclass.send :define_method, :previous_page, &lambda{
          if response.has_key?("paging") and response["paging"].has_key?("previous")
            page_path = response["paging"]["previous"].split("?").first
            page_params = url_unpack(response["paging"]["previous"].split("?").last).delete_if{ |k,v| k.eql?(:access_token) }

            list_class.new(page_path,client).list(page_params)
          else
            []
          end
        }
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
end