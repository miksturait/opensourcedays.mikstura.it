class ApiInfo::WhosHere
  class << self
    def data
      {
          sponsors: prepare_collection(:sponsors),
          media: prepare_collection(:media),
          organizers: prepare_collection(:organizers)
      }
    end

    def prepare_collection(type)
      collection = send(type)
      collection.collect do |(code, link)|
        {
            avatar_url: image_url(type, code),
            link: link
        }
      end
    end

    private

    def sponsors
      {
          "microsoft_openness" => 'http://www.microsoft.com/en-us/openness/default.asp',
          "selleo" => 'http://selleo.com/',
          "travis" => 'http://travis-ci.com/',
          "rekord" => 'http://www.rekord.com.pl/'
      }
    end

    def media
      {
          'magazyn.programista' => 'http://programistamag.pl/',
          'bb365info' => 'http://www.bb365.info/'
      }
    end

    def organizers
    {
        'mikstura.it' => 'http://mikstura.it',
        'ath' => 'http://info.ath.bielsko.pl/',
        'ath.reset' => 'http://reset.ath.bielsko.pl/'
    }
    end

    def image_url(type, code)
      [I18n.t(:domain), "assets/#{type}/logo", "#{code}.png"].join("/")
    end
  end
end