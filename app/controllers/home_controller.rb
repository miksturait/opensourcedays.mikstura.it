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
  expose(:talk_groups) { TalkGroup.all('Presentations') }
  expose(:workshops) { Talk.all('Workshops').sort_by(&:start_at) }
  expose(:days) { event_data.talks_groups.map { |talk_group| talk_group.date } }
  expose(:sponsor_groups) { PartnerGroup.all.reject { |group| group.name == 'Media' || group.name == 'Organizers' } }
  expose(:media) { PartnerGroup.all('Media').partners }
  expose(:organisers) { PartnerGroup.all('Organizers').partners }
  expose(:partner_groups) { PartnerGroup.all }
  expose(:team_members) { TeamMember.all }
  expose(:mikstura_links) {event_data_about["social_profile_links"]}

  def index

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


  def event_data
    @event_data ||= Api::EventData.new
  end

  def event_data_about
    event_data.about
  end
end
