class ApiInfo::Schedule
  class << self
    def clear
      @days_data = []
      @talks_data = []
      @speakers_talks_data = []
    end

    def data
      clear
      collect_talks
      {
          talk_groups: days_data.uniq,
          talks: talks_data.uniq,
          speakers_talks: speakers_talks_data.uniq,
          talk_locations: talk_locations_data
      }
    end

    private

    def collect_talks
      [:dayone, :daytwo, :daythree].collect do |day|
        days_data.push({
                           id: t(:id, scope: [:schedule, day]),
                           date: t(:date, scope: [:schedule, day]),
                           title: t(:title, scope: [:schedule, day])
                       })
        sorted_keys = t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort
        sorted_keys.collect do |agenda_key|
          talk = Talk.new(agenda_key, day)
          talks_data.push talk.to_hash
          talk.speakers.each do |speaker|
            speakers_talks_data.push({
                                         speaker_id: speaker.id,
                                         talk_id: talk.info_id
                                     })
          end
        end

        Workshop.all_workshops.each do |workshop|
          talks_data.push workshop.to_hash
          workshop.speakers.each do |speaker|
            speakers_talks_data.push({
                                         speaker_id: speaker.id,
                                         talk_id: workshop.info_id
                                     })
          end
        end
      end
    end

    def talk_locations_data
      t('venue.places').values
    end

    def days_data
      @days_data ||= []
    end

    def talks_data
      @talks_data ||= []
    end

    def speakers_talks_data
      @speakers_talks_data ||=[]
    end

    def t(*args)
      I18n.t(*args)
    end
  end
end