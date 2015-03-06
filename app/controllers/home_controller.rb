class HomeController < ApplicationController
  layout 'base'
  after_action :cache_it, only: [:index, :rules, :policy]

  def index
    prepare_team
    prepare_speakers
    prepare_talks
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

  def prepare_speakers
    @speakers = %w(Karol_Ryt Dariusz_Wylon Heitor_Medrado Michal_Papis Agnieszka_Pawlicka Marek_Wiera Michal_Zyndul Tomasz_Borowski Slawomir_Rewaj Karol_Karczewski Marcin_Hlybin Mikolaj_Pastuszko Marcin_Szalowicz Arkadiusz_Kwasny Henryk_Konsek Tomasz_Bak Mateusz_Juscinski Michal_Czyz Katarzyna_Pawlonka Ryszard_Dalkowski).
        map { |speaker| Person.new(speaker) }
  end

  def prepare_team
    @team = %w(Dominik_Kozaczko Eunika_Tabak Dariusz_Wylon Michal_Czyz Tomasz_Gancarczyk Grzegorz_Rduch Marcin_Szalowicz Anna_Warzecha Katarzyna_Jasiewicz Joanna_Walus Pawel_Rudyk Lukasz_Czulak Tomasz_Kaminski Krzysztof_Gren Andrzej_Kastelik Pawel_Krusinski Beata_Goluch Piotr_Juroszek Justyna_Jasek Michal_Krzus Janusz_Zukowicz Jan_Frindt Maciej_Kwasniak Artur_Loska).map { |speaker| Person.new(speaker) }
  end

  def prepare_talks
    @talks = [:dayone, :daytwo, :daythree].each_with_object({}) do |day, cache|
      cache[day] = I18n.t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort.collect do |agenda_key|
        Talk.new(agenda_key, day)
      end
    end
  end
end
