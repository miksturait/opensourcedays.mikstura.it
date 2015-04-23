class HomeController < ApplicationController
  layout 'base'
  after_action :cache_it, only: [:index, :rules, :policy]
  expose(:page_title) { event_data_about["short_title"] }
  expose(:full_page_title) { event_data_about["title"] }
  expose(:description) { event_data_about["description"] }
  expose(:navigation_texts) { event_data_about["texts"] }
  expose(:address) { event_data_about["location"]["address"] }
  expose(:speakers) { event_data.speakers }
  expose(:talks) { event_data.talks }
  expose(:speaker_talks) { event_data.speakers_talks }
  expose(:presentations) { event_data.talks.select { |talk| talk.track_name == 'Presentations' } }
  expose(:workshop) { event_data.talks.select { |talk| talk.track_name == 'Workshops' } }
  expose(:talk_groups) { TalkGroup.all('Agenda') }
  expose(:workshops) {Talk.all('Warsztaty').sort_by(&:start_at)}
  expose(:days) { event_data.talks_groups.map { |talk_group| talk_group.date } }
  expose(:gold_sponsor) {PartnerGroup.all('Gold Sponsor').partner}
  expose(:silver_sponsors) {PartnerGroup.all('Silver Sponsors').partners}
  expose(:supporters) {PartnerGroup.all('Supporters')}

  def index
    prepare_team
  end

  def rules
    render template: '/legal/rules', layout: 'plain'
  end

  def policy
    render template: '/legal/policy', layout: 'plain'
  end

  private

  def cache_it
    cache_page(nil, "/#{I18n.locale}/#{action_name}.html")
  end

  def prepare_team
    @team = %w(Dominik_Kozaczko Eunika_Tabak Dariusz_Wylon Michal_Czyz Tomasz_Gancarczyk Grzegorz_Rduch Marcin_Szalowicz Katarzyna_Jasiewicz Joanna_Walus Pawel_Rudyk Lukasz_Czulak Tomasz_Kaminski Krzysztof_Gren Andrzej_Kastelik Pawel_Krusinski Beata_Goluch Piotr_Juroszek Justyna_Jasek Michal_Krzus Janusz_Zukowicz Jan_Frindt Maciej_Kwasniak Artur_Loska Bartosz_Szczepanski Bartlomiej_Borak Marcin_Wadon)
                .map { |speaker| Person.new(speaker) }
  end

  def prepare_talks
    @talks = [:dayone, :daytwo, :daythree].each_with_object({}) do |day, cache|
      cache[day] = I18n.t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort.collect do |agenda_key|
        # Talk.new([agenda_key, day])
      end
    end
  end

  def event_data
    @event_data ||= Api::EventData.new
  end

  def event_data_about
    event_data.about
  end
end
