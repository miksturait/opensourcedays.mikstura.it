class ApiInfo::Workshops
  class << self
    def data
      collect_workshops
    end


    def collect_workshops
      [:daytwo, :daythree].collect do |day|
        {
            date: t(:date, scope: [:schedule, day]),
            title: t(:title, scope: [:schedule, day]),
            label: t(:header, scope: [:schedule, day]),
            talks: send(day)
        }
      end
    end

    def daytwo
      all[0..2].flatten.map(&:to_hash)
    end

    def daythree
      all[3..4].flatten.map(&:to_hash)
    end

    def all
      ::Workshop.all
    end

    def t(*args)
      I18n.translate(*args)
    end
  end
end