module Api
  class EventData

    include HTTParty
    base_uri 'http://eventguide.mikstura.it/v4/open-source-days-14-backup/pl.json'
    format :json

    def about
      data.parsed_response["about"]
    end

    def talks_groups
      build_collection('talk_groups', TalkGroup)
    end

    def feedback_groups
      build_collection('feedback_groups')
    end

    def workshops
      build_collection('workshops')
    end

    def talks
      build_collection('talks', Talk)
    end

    def tracks
      build_collection('tracks')
    end

    def talks_tracks
      build_collection('talks_tracks')
    end

    def speakers_talks
      build_collection('speakers_talks', SpeakerTalk)
    end

    def talks_locations
      build_collection('talk_locations')
    end

    def speakers
      build_collection('speakers')
    end

    def partners_groups
      build_collection('partner_groups')
    end

    def partners
      build_collection('partners')
    end

    private

    def data
      @data ||=
          HTTParty.get("http://eventguide.mikstura.it/v4/open-source-days-14/pl.json")
    end

    def build_collection(key, decorate_by=OpenStruct)
      data[key].map do |element|
        decorate_by.new(element).tap do |decorated_element|
          decorated_element.data_source = self if decorated_element.respond_to?(:data_source)
        end
      end.sort_by(&:position)
    end
  end
end

