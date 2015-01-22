class Workshop < Struct.new(:id, :timeslot)

  def self.all
    if I18n.translate('workshops').is_a?(Hash)
      workshops_schedule = I18n.translate('workshops_schedule').reverse
      [
          [:azure, :open_source, :your_own_parser],
          [:mindstorms, :ember_js],
          [:open_street_map, :continuous_delivery],
          [:humanitarian, :feedback],
          [:ux, :firefoxos, :unity3d]
      ].collect do |workshops|
        schedule = workshops_schedule.pop
        workshops.collect { |workshop| new(workshop, schedule) }
      end
    else
      []
    end
  end

  def self.all_workshops
    if I18n.translate('workshops').is_a?(Hash)
      I18n.t('workshops').keys.collect { |key| Workshop.new(key, nil) }.sort { |a, b| [a.send(:day_id), a.send(:start_at)].join('_') <=> [b.send(:day_id), b.send(:start_at)].join('_') }
    else
      []
    end
  end

  def title
    info_title
  end

  def description
    [info_description].flatten
  end

  delegate :name, :code, to: :place, prefix: true

  def place
    OpenStruct.new(
        I18n.t(info_where, scope: [:venue, :places]))
  end

  def lead_names
    leaders.map(&:name)
  end

  def lead_pictures
    leaders.map(&:picture)
  end

  def speakers
    if info_leads
      info_leads.map { |info_lead| Person.new(info_lead) }
    else
      []
    end
  end

  def leaders
    speakers
  end

  def info_leads
    info_lead.is_a?(Array) ? info_lead : [info_lead]
  end

  delegate :type, :logo, :day, :start_at, to: :info
  delegate :id, :where, :title, :description, :lead, to: :info, prefix: true

  def logo_url
    [I18n.t(:domain), 'assets/workshops', logo].join("/")
  end

  def to_hash(position = 0)
    {
        id: info_id,
        position: position,
        talk_group_id: day_id,
        talk_location_id: place.id,
        more_info: true,
        start_at: start_at_date,
        end_at: end_at_date,
        type: 'workshop',
        subtype: nil,
        image_url: image_url,
        logo_url: logo_url,
        title: title,
        description_paragraphs: description,
        tags: nil,
        social_share_text: social_share_text
    }
  end

  private

  def social_share_text
    ['#dwo14', "##{id}", speakers_twitter_handles].join(' ')
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

  def start_at_date
    Time.parse([date, start_at].join(' '))
  end

  def end_at_date
    start_at_date + 90.minutes
  end

  def date
    t(:date, scope: [:schedule, day])
  end

  def day_id
    t(:id, scope: [:schedule, day])
  end

  def image_url
    if speakers.size > 1
      picture_filename = speakers.map(&:key).collect { |some_key| some_key.gsub(/[a-z]/, '') }.join('_') << '.png'
      [I18n.t(:domain), 'assets/speakers', picture_filename].join("/")
    elsif speakers.size == 1
      speakers.first.avatar_url
    end
  end


  def info
    @info ||=
        OpenStruct.new(
            I18n.translate(id, scope: [:workshops]))
  end

  def t(*args)
    I18n.t(*args)
  end
end
