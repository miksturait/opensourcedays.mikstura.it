class Talk < Struct.new(:id, :day, :position)

  def self.all_talks
    %i(dayone daytwo daythree).collect do |day|
      I18n.translate(:agenda, scope: [:schedule, day]).keys.collect do |key|
        new(key, day)
      end
    end.flatten
  end

  def title
    info_title ||
        I18n.t(:header, scope: [:schedule, type])
  end

  def description
    [fetch_description].flatten
  end

  # TODO - handle more then one speaker
  def speakers
    if info_speaker
      [info_speaker].flatten.collect do |speaker_key|
        Person.new(speaker_key)
      end
    else
      []
    end
  end

  delegate :type, to: :info
  delegate :id, :title, :description, :speaker, to: :info, prefix: true

  def place
    OpenStruct.new(
        I18n.t(:main, scope: [:venue, :places]))
  end

  def start_at
    time.strftime(time_format)
  end

  def start_at_24_hour_format
    time.strftime("%H:%M")
  end

  def date_time_format(some_key)
    Time.parse([date, some_key.to_s.sub("-", ":")].join(' '))
  end

  def to_hash
    {
        id: info_id,
        position: position,
        talk_group_id: day_id,
        talk_location_id: place.id,
        more_info: more_info,
        start_at: date_time_format(id),
        end_at: date_time_format(end_at_as_key),
        type: 'presentation',
        subtype: type,
        image_url: image_url,
        logo_url: nil,
        title: title,
        description_paragraphs: description,
        tags: nil,
        social_share_text: social_share_text
    }
  end

  private

  def social_share_text
    if more_info
      ['#dwo14', speakers_twitter_handles].join(' ')
    else
      ''
    end
  end

  def speakers_twitter_handles
    speakers.collect do |s|
      if s.social[:twitter] && s.social[:twitter] =~ /.*\/\/twitter.com\/.*/
        s.social[:twitter].gsub(/.*\/\/twitter.com\//, '@')
      else
        s.name
      end
    end.compact.join(' & ')
  end

  def image_url
    if speakers.size > 1
      picture_filename = speakers.map(&:key).collect { |some_key| some_key.gsub(/[a-z]/, '') }.join('_') << '.png'
      [I18n.t(:domain), 'assets/speakers', picture_filename].join("/")
    elsif speakers.size == 1
      speakers.first.avatar_url
    end
  end

  def more_info
    %w(talk keynote).include? type
  end

  def fetch_description
    info_description ||
        I18n.t(:description, scope: [:schedule, type])
  end

  def time
    Time.parse(id.to_s.sub("-", ":"))
  end

  def time_format
    {en: "%l:%M %P", pl: "%H:%M"}[I18n.locale]
  end

  def date
    t(:date, scope: [:schedule, day])
  end

  def day_id
    t(:id, scope: [:schedule, day])
  end

  def end_at_as_key
    sorted_keys = t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort
    sorted_keys[sorted_keys.index(id) + 1] || (time + 15.minutes).strftime("%H-%M")
  end

  def info
    @info ||=
        OpenStruct.new(
            I18n.translate(id, scope: [:schedule, day, :agenda]))
  end

  def t(*args)
    I18n.t(*args)
  end
end