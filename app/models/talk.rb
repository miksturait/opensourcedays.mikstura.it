class Talk < ApiObject
  LINE_PARSING_REGEXP = /(?<time>(\d{2}:\d{2}))/
  LINE_PARSING_REGEXP2 = /(?<date>(.{4}(-.{2}){2}))/
  delegate :end_at,
           :start_at,
           :id,
           :image_url,
           :social_share_text,
           :title,
           :style,
           :talk_group_id,
           :description_paragraphs,
           :more_info,
           :talk_location_id,
           :tags,
           :position,
           to: :attributes

  def speakers
    data_source.speakers.select do |speaker|
      speaker_ids.include?(speaker.id)
    end
  end

  def speaker
    speakers.first
  end

  def self.all(track_name=nil)
    data_source.talks.tap do |talks|
      talks.select! { |talk| talk.track_name == track_name } if track_name
    end
  end

  def start_at
    Time.parse(attributes.start_at)
  end

  def time_slot
    "#{day}, #{hour_start_at}-#{end_at}"
  end

  def hour_start_at
    LINE_PARSING_REGEXP.match(attributes.start_at)
  end

  def track_name
    data_source.tracks.find { |track| track.id == talk_track.track_id }.name
  end

  def talk_location
    "#{talk_loc_desc}, #{talk_loc_room}"
  end

  private

  def talk_loc_desc
    data_source.talks_locations.find { |location| location.id == talk_location_id }.name
  end

  def talk_loc_room
    data_source.talks_locations.find { |location| location.id == talk_location_id }.code
  end

  def end_at
    LINE_PARSING_REGEXP.match(attributes.end_at)
  end

  def day
    LINE_PARSING_REGEXP2.match(attributes.end_at)
  end

  def talk_track
    data_source.talks_tracks.find { |talk_track| talk_track.talk_id == id }
  end

  def speakers_talks
    data_source.speakers_talks.select do |speaker_talk|
      speaker_talk.talk_id == id
    end
  end

  def speaker_ids
    @speaker_ids ||= speakers_talks.map(&:speaker_id)
  end
end
