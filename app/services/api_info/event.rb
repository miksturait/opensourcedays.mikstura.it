class ApiInfo::Event
  def self.data
    {
        event: prepare_data
    }
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
    scope = ['event', type]
    key = [type, platform].map(&:to_s).join('_')
    general = I18n.t(:general, scope: scope)
    platform = I18n.t(platform, scope: scope)
    value = (platform.is_a?(Hash) ? general.merge(platform) : general)
    value = (just_a_list ? value.values : value)
    {
        key => value
    }
  end
end
