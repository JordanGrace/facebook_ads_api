module FacebookAdsApi
  ##
  #
  class Accounts < GraphObjects 
    def initialize(path, client, params={})      
      super path, client, params
    end
  end

  ##
  #
  class Account < GraphObject
    ##
    #
    def initialize(path, client, params={})
      super fix_path(path), client, params

      resource :report_stats
    end

    private

    ##
    #
    def fix_path(path)
      path_segments = path.split("/")
      "/" + path_segments[1] + "/act_" + path_segments[2]
    end
  end
end