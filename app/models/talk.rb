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

  # def self.all_talks
  #   %i(dayone daytwo daythree dayfour dayfive daysix).collect do |day|
  #     I18n.translate(:agenda, scope: [:schedule, day]).keys.collect do |key|
  #       new(key, day)
  #     end
  #   end.flatten
  #
  # end
  #
  # def title
  #   info_title ||
  #       I18n.t(:header, scope: [:schedule, type])
  # end
  #
  # def description
  #   [fetch_description].flatten
  # end

  # TODO - handle more then one speaker
  # def speakers
  #   if info_speaker
  #     [info_speaker].flatten.collect do |speaker_key|
  #       Person.new(speaker_key)
  #     end
  #   else
  #     []
  #   end
  # end
  #
  # def speaker
  #   speakers.first
  # end
  #
  # delegate :type, to: :info
  # delegate :id, :title, :description, :speaker, to: :info, prefix: true
  #
  # def place
  #   OpenStruct.new(
  #       I18n.t(:main, scope: [:venue, :places]))
  # end
  #
  # def start_at
  #   time.strftime(time_format)
  # end
  #
  # def start_at_24_hour_format
  #   time.strftime("%H:%M")
  # end
  #
  # def date_time_format(some_key)
  #   Time.parse([date, some_key.to_s.sub("-", ":")].join(' '))
  # end
  #
  # def to_hash
  #   {
  #       id: info_id,
  #       position: position,
  #       talk_group_id: day_id,
  #       talk_location_id: place.id,
  #       more_info: more_info,
  #       start_at: date_time_format(id),
  #       end_at: date_time_format(end_at_as_key),
  #       type: group_type,
  #       subtype: type,
  #       image_url: image_url,
  #       logo_url: nil,
  #       title: title,
  #       description_paragraphs: description,
  #       tags: nil,
  #       social_share_text: social_share_text
  #   }
  # end
  #
  # private
  #
  # def group_type
  #   t('type', scope: [:schedule, day])
  # end
  #
  # def social_share_text
  #   if more_info
  #     [hashtag, speakers_twitter_handles].join(' ')
  #   else
  #     hashtag
  #   end
  # end
  #
  # def hashtag
  #   t('hashtag')
  # end
  #
  # def speakers_twitter_handles
  #   speakers.collect do |s|
  #     if s.social && s.social[:twitter] && s.social[:twitter] =~ /.*\/\/twitter.com\/.*/
  #       s.social[:twitter].gsub(/.*\/\/twitter.com\//, '@')
  #     else
  #       s.name
  #     end
  #   end.compact.join(' & ')
  # end
  #
  # def image_url
  #   if speakers.size > 1
  #     picture_filename = speakers.map(&:key).collect { |some_key| some_key.gsub(/[a-z]/, '') }.join('_') << '.png'
  #     [I18n.t(:domain), 'assets/speakers', picture_filename].join("/")
  #   elsif speakers.size == 1
  #     speakers.first.avatar_url
  #   else
  #     [I18n.t(:domain), 'assets/speakers/pinguin.jpg'].join("/")
  #   end
  # end
  #
  # def more_info
  #   %w(talk keynote).include? type
  # end
  #
  # def fetch_description
  #   info_description ||
  #       I18n.t(:description, scope: [:schedule, type])
  # end
  #
  # def time
  #   Time.parse(id.to_s.sub("-", ":"))
  # end
  #
  # def time_format
  #   {en: "%l:%M %P", pl: "%H:%M"}[I18n.locale]
  # end
  #
  # def date
  #   t(:date, scope: [:schedule, day])
  # end
  #
  # def day_id
  #   t(:id, scope: [:schedule, day])
  # end
  #
  # def end_at_as_key
  #   sorted_keys = t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort
  #   sorted_keys[sorted_keys.index(id) + 1] || (time + 15.minutes).strftime("%H-%M")
  # end
  #
  # def info
  #   @info ||=
  #       OpenStruct.new(
  #           I18n.translate(id, scope: [:schedule, day, :agenda]))
  # end
  #
  # def t(*args)
  #   I18n.t(*args)
  # end
end
