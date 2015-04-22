module HomeHelper
  def i18n_switch_link
    {en: 'http://dwo.mikstura.it', pl: 'http://opensourcedays.mikstura.it'}[I18n.locale]
  end

  def i18n_switch_flag
    image_tag("/assets/layout/flags/#{{en: 'pl', pl: 'gb'}[I18n.locale]}.png", style: "height: 16px")
  end

  def i18n_switch
    link_to i18n_switch_link, class: 'external' do
      i18n_switch_flag
    end
  end

  def tabs_for_talk_groups(talk_groups, &block)
    talk_groups.each do |talk_group|
      conference_days = talk_groups.map(&:date)
      is_active = if conference_days.include?(Date.today)
                    Date.today == talk_group.date
                  else
                    conference_days.first == talk_group.date
                  end
      block.call(talk_group, is_active)
    end
  end


  def as_word(id)
    case id
      when 1
        "one"
      when 2
        "two"
      when 3
        "three"
    end
  end

  # # !(talk_groups.map { |talk_group| talk_group.date }.first == Date.today ||
  # # == talk_group.date
  #
  # def day_is_active(id, date)
  #   # today = Date.today
  #   # if Date.today == Date.parse(date)
  #   #   'active'
  #   # else
  #   #   nil
  #   # end
  #   # if day == :dayone and today == Date.new(2014, 3, 28)
  #   #   'active'
  #   # elsif day == :daytwo and today == Date.new(2014, 3, 29)
  #   #   'active'
  #   # elsif day == :daythree and today == Date.new(2014, 3, 30)
  #   #   'active'
  #   # elsif day == :dayone
  #   #   'active'
  #   # else
  #   #   nil
  #   # end
  #
  #   # if (dzien jest posrod dni konferencji) and (dzien jest dzisiaj)
  #   # active
  #   # elsif (dzien nie jest posrod dni konferencji)
  #   #
  #   # end
  #   #
  #
  #   if Api::EventData.new.talks_groups.map { |talk_group| talk_group.date }.include?(date)
  #     if Date.today == Date.parse(date)
  #       true
  #     end
  #   elsif Api::EventData.new.talks_groups.map { |talk_group| talk_group.date }.first == Date.parse(date)
  #     true
  #   end
  # end

  def icon_by_type(type)
    class_name = {
        registration: 'iconf-eventbrite',
        keynote: 'iconf-microphone',
        talk: 'iconf-microphone',
        panel: 'iconf-dialogue-box',
        #breakfest: 'iconf-fast_food',
        breakfest: 'iconf-cup',
        lightningtalks: 'iconf-microphone',
        break: 'iconf-coffee',
        #lunch: 'iconf-pizza',
        lunch: 'iconf-food',
        welcome: 'iconf-megaphone',
        party: 'iconf-wine',
        bye: 'iconf-graduation-cap',
        see_you_tomorrow: 'iconf-megaphone'
    }[type.to_sym]

    content_tag(:i, nil, class: class_name)
  end
end
