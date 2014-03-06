class ApiInfo::Workshops
  class << self
    def data
      Workshop.all_to_hash
    end
  end
end