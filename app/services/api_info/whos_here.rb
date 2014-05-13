class ApiInfo::WhosHere
  class << self
    def data
      {
          speakers: speakers_data,
          partners: partners_data,
          partner_groups: partners_types_data
      }
    end


    def prepare_collection(type)
      collection = send(type)
      collection.collect do |(code, data)|
        {
            id: data[:id],
            partner_group_id: partner_types[type],
            logo_url: image_url(type, code),
            website_url: data[:link]
        }
      end
    end

    private

    def partners_data
      [prepare_collection(:sponsors),
       prepare_collection(:media),
       prepare_collection(:organizers)].flatten
    end

    def speakers_data
      Person.all.map(&:to_hash)
    end

    def partner_types
      I18n.t('partner_types')
    end

    def partners_types_data
      partner_types.enum_for(:each_with_index).collect do |(name, id), position|
        {
            id: id,
            position: position,
            name: name
        }
      end
    end

    def sponsors
      {
          "microsoft_openness" => {
              link: 'http://www.microsoft.com/en-us/openness/default.asp',
              position: 0,
              id: 1},
          "selleo" => {
              link: 'http://selleo.com/',
              position: 1,
              id: 2},
          "red_hat" => {
              link: 'http://www.redhat.com/',
              position: 2,
              id: 3},
          "travis" => {
              link: 'http://travis-ci.com/',
              position: 3,
              id: 4},
          "rekord" => {
              link: 'http://www.rekord.com.pl/',
              position: 4,
              id: 5},
      }
    end

    def media
      {
          'magazyn.programista' => {
              link: 'http://programistamag.pl/',
              position: 0,
              id: 6},
          'bb365info' => {
              link: 'http://www.bb365.info/',
              position: 1,
              id: 7},
          'sdjournal' => {
              link: 'http://sdjournal.pl/',
              position: 2,
              id: 8},
          'pracait' => {
              link: 'http://pracait.com/',
              position: 3,
              id: 9},
          'webmastah' => {
              link: 'http://webmastah.pl',
              position: 4,
              id: 10}
      }
    end

    def organizers
      {
          'mikstura.it' => {
              link: 'http://mikstura.it',
              position: 0,
              id: 11},
          'ath' => {
              link: 'http://info.ath.bielsko.pl/',
              position: 1,
              id: 12},
          'ath.reset' => {
              link: 'http://reset.ath.bielsko.pl/',
              position: 2,
              id: 13}
      }
    end

    def image_url(type, code)
      [I18n.t(:domain), "assets/#{type}/logo", "#{code}.png"].join("/")
    end
  end
end