class ApiInfo::Workshops
  class << self
    def data
      workshops.map(&:to_hash)
    end

    def workshops
      @workshops ||=
          workshops_keys.collect { |workshop_id| ::Workshop.new(workshop_id) }
    end

    def workshops_keys
      I18n.t('workshops').keys
    end
  end
end