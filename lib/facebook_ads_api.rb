require "facebook_ads_api/version"

module FacebookAdsApi
  require "cgi"
  require 'net/http'
  require 'net/https'
  require 'multi_json'

  require 'facebook_ads_api/utils'
  require 'facebook_ads_api/errors'
  require 'facebook_ads_api/graph_object'
  require 'facebook_ads_api/graph_objects'

  require 'facebook_ads_api/client'
  require 'facebook_ads_api/accounts'
  require 'facebook_ads_api/accounts/insights'
end
