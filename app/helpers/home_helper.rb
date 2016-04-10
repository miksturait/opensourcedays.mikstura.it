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
