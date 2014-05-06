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
            link: data[:link]
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
      partner_types.collect do |name, id|
        {
            id: id,
            name: name
        }
      end
    end

    def sponsors
      {
          "microsoft_openness" => {
              link: 'http://www.microsoft.com/en-us/openness/default.asp',
              id: 1},
          "selleo" => {
              link: 'http://selleo.com/',
              id: 2},
          "red_hat" => {
              link: 'http://www.redhat.com/',
              id: 3},
          "travis" => {
              link: 'http://travis-ci.com/',
              id: 4},
          "rekord" => {
              link: 'http://www.rekord.com.pl/',
              id: 5},
      }
    end

    def media
      {
          'magazyn.programista' => {
              link: 'http://programistamag.pl/',
              id: 6},
          'bb365info' => {
              link: 'http://www.bb365.info/',
              id: 7},
          'sdjournal' => {
              link: 'http://sdjournal.pl/',
              id: 8},
          'pracait' => {
              link: 'http://pracait.com/',
              id: 9},
          'webmastah' => {
              link: 'http://webmastah.pl',
              id: 10}
      }
    end

    def organizers
      {
          'mikstura.it' => {
              link: 'http://mikstura.it',
              id: 11},
          'ath' => {
              link: 'http://info.ath.bielsko.pl/',
              id: 12},
          'ath.reset' => {
              link: 'http://reset.ath.bielsko.pl/',
              id: 13}
      }
    end

    def image_url(type, code)
      [I18n.t(:domain), "assets/#{type}/logo", "#{code}.png"].join("/")
    end
  end
end