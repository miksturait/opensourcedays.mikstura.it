class Person < Struct.new(:key)

  def self.all
    # I18n.t('people').keys.collect { |person_key| new(person_key) }
    Api::EventData.speakers.map { |speaker| new("#{speaker.first_name}_#{speaker.last_name}") }
  end

  def picture(extension='jpg')
    "#{key}.#{extension}"
  end

  delegate :social, to: :info, prefix: true
  delegate :id, :name, :title, :description, :social, to: :info

  def info
    @info ||=
        OpenStruct.new(
            I18n.translate(key, scope: [:people]))
  end

  def social
    info_social || {}
  end

  def to_hash
    {
        id: id,
        social_profile_links: social,
        rectangle_image_url: avatar_url,
        ellipse_image_url: ellipse_avatar_url,
        title: title,
        first_name: first_name,
        last_name: last_name,
        description_paragraphs: flatten_description,
    }
  end

  def flatten_description
    [description].flatten
  end

  def avatar_url
    [I18n.t(:domain), 'assets/speakers', picture].join("/")
  end

  def ellipse_avatar_url
    [I18n.t(:domain), 'assets/speakers_ellipse', picture('png')].join("/")
  end

  def first_name
    name.split(' ').first
  end

  def last_name
    name.split(' ').last
  end
end
