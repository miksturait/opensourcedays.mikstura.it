class MobileApi
  def self.data
    {
        time_stamp: Time.now,
        about: ApiInfo::About.data,
    }.
        merge(ApiInfo::Schedule.data).
        merge(ApiInfo::WhosHere.data)
  end
end

