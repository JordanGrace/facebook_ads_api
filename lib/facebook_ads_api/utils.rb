module FacebookAdsApi
  module Utils
    ##
    #
    def url_encode(hash)
      hash.to_a.map{ |a| a.map.with_index { |b,i| i.eql?(1) ? MultiJson.dump(b) : b }.join '=' }.join '&'
    end

    ##
    #
    def resourceify(name)
      name.to_s.split("_").map! do |s|
        [s[0,1].capitalize, s[1..-1]].join
      end.join
    end
  end
end