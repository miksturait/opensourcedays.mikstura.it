class Workshop < Struct.new(:id, :timeslot)

  def self.all
    workshops_schedule = I18n.translate('workshops_schedule').reverse
    [
        [:open_source, :your_own_parser],
        [:mindstorms, :ember_js],
        [:open_street_map, :continuous_delivery],
        [:unity3d, :feedback],
        [:ux, :firefoxos]
    ].collect do |workshops|
      schedule = workshops_schedule.pop
      workshops.collect { |workshop| new(workshop, schedule) }
    end
  end

  def self.all_to_hash
    all.flatten.map(&:to_hash)
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

  def leaders
    info_leads.map { |info_lead| Person.new(info_lead) }
  end

  def info_leads
    info_lead.is_a?(Array) ? info_lead : [info_lead]
  end

  delegate :type, :logo, to: :info
  delegate :where, :title, :description, :lead, to: :info, prefix: true

  def logo_url
    [I18n.t(:domain), 'assets/workshops', logo].join("/")
  end

  def to_hash
    {
        id: info.id,
        more_info: true,
        start_at: timeslot,
        type: 'workshop',
        vanue: place,
        title: title,
        logo: logo_url,
        description: description,
        speakers: leaders.map(&:to_hash)
    }
  end


  private

  def workshops_schedule

  end

  def info
    @info ||=
        OpenStruct.new(
            I18n.translate(id, scope: [:workshops]))
  end
end