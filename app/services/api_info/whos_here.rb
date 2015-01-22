class ApiInfo::WhosHere
  class << self
    def data
      {
          speakers: speakers_data,
          partners: prepare_collection,
          partner_groups: partners_types_data
      }
    end

    private

    def prepare_collection
      [
          {
             link: 'http://mikstura.it',
             avatar_url: '/assets/organizers/logo/mikstura.it.png'
          },
          {
              link: 'http://info.ath.bielsko.pl/',
              avatar_url: '/assets/organizers/logo/ath.png'
          },
          {
              link: 'http://reset.ath.bielsko.pl/',
              avatar_url: '/assets/organizers/logo/ath.reset.png'
          }
      ]
      # I18n.t('partners').collect do |(code, data)|
      #   data.merge({logo_url: image_url(code)})
      # end
    end

    def speakers_data
      Person.all.map(&:to_hash)
    end

    def partner_types
      I18n.t('partner_types')
    end

    def partners_types_data
      @partner_types_data ||=
          partner_types.enum_for(:each_with_index).collect do |(name, id), position|
            {
                id: id,
                position: position,
                name: I18n.t(name, scope: [:section, :mobile])
            }
          end
    end

    def image_url(code)
      [I18n.t(:domain), "assets/logo", "#{code}.png"].join("/")
    end
  end
end
