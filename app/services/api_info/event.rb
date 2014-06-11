class ApiInfo::Event
  def self.data
    prepare_data
  end

  def self.prepare_data
    data = {}
    %i(ios android wp).each do |platform|
      %i(navigation feedback_items).each do |type|
        data.merge!(
            data_for(type, platform, type == :feedback_items)
        )
      end
    end
    data
  end

  def self.data_for(type, platform, just_a_list)
    i18n_scope = ['event', type].join('.')
    key = [type, platform].map(&:to_s).join('_')
    general_data = I18n.t(:general, scope: i18n_scope)
    platform_specific = I18n.t(i18n_scope)[platform]
    value = (platform_specific.is_a?(Hash) ? general_data.merge(platform_specific) : general_data)
    value = (just_a_list ? value.values : value)
    {
        key => value
    }
  end
end
