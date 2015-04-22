class TalkGroup < ApiObject
  attr_accessor :active, :filtered_for_track
  delegate :title, :position, :date, :id, to: :attributes

  def talks
    data_source.talks.select do |talk|
      talk.talk_group_id == id && (filtered_for_track == talk.track_name || filtered_for_track.nil? )
    end
  end

  def self.find_by_title(title)
    data_source.talks_groups.select { |talk_group| talk_group.title == title }.first
  end

  def self.all(track_name=nil)
    data_source.talks_groups.sort_by(&:position).each { |talk_group| talk_group.filtered_for_track = track_name }
  end
end