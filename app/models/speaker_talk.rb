class SpeakerTalk < ApiObject
  delegate :talk_id, :speaker_id, :position, to: :attributes

  def speakers
    data_source.speakers.select do |speaker|
      speaker.id == speaker_id
    end
  end

  def self.all
    Api::EventData.new.speakers_talks
  end
end