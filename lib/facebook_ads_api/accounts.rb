module FacebookAdsApi
  ##
  # Accounts: Inherits from GraphObjects class.  This class remains unfinished
  # due to the lack of ads_manage permissions access to the Ads API.
  class Accounts < GraphObjects
    ##
    # initlaize: Accepts a non optional path, client, and optional params hash.
    # path is the string representation that is used to build the path used in a
    # communication to the Facebook API.  Client a current instatance of the Client
    # class.  Params allows the passing of filters provided by the Facebook API
    # such as time_ranges.
    def initialize(path, client, params={})
      super path, client, params
    end
  end

  ##
  # Account: Inherits from GraphObject class.  This class remains unfinished
  # due to the lack of ads_manage permissions access to the Ads API.
  class Account < GraphObject
    ##
    # initlaize: Accepts a non optional path, client, and optional params hash.
    # path is the string representation that is used to build the path used in a
    # communication to the Facebook API.  Client a current instatance of the Client
    # class.  Params allows the passing of filters provided by the Facebook API
    # such as time_ranges.  report_stats resource is also intialized.
    def initialize(path, client, params={})
      super fix_path(path), client, params

      resource :insights
    end

    private

    ##
    # fix_path: This method produces the appropriate path for accessing the account
    # resource.  Facebook Ads Accouts using an "act_" prefix to the account_id.  This
    # method ensures the prefix is added to it's path.
    def fix_path(path)
      path_segments = path.split("/")
      "/" + path_segments[1] + "/act_" + path_segments[2]
    end
  end
end