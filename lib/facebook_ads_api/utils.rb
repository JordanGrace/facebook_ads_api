module FacebookAdsApi
  module Utils
    ##
    #
    def url_encode(hash)
      hash.to_a.map do |a| 
        a.map.with_index do |b,i| 
          if i.eql?(1) && !b.is_a?(String)
            MultiJson.dump(b)
          else
            b
          end 
        end.join '='
      end.join '&'
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