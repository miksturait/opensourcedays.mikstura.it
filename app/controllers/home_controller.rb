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
    @speakers = %w(Karol_Ryt Dariusz_Wylon Heitor_Medrado Michal_Papis Agnieszka_Pawlicka Marek_Wiera Michal_Zyndul Tomasz_Borowski Slawomir_Rewaj Karol_Karczewski Agnieszka_Pilch Marcin_Hlybin Mikolaj_Pastuszko Arkadiusz_Kwasny Marcin_Szalowicz Lukasz_Zemczak Katarzyna_Pawlonka Lukasz_Wieclaw Ryszard_Dalkowski Jaroslaw_Czub Tomasz_Bak Krzysztof_Ksiazek Martyna_Bargiel Mateusz_Juscinski Krystian_Cieslak Michal_Czyz Wojtek_Gawronski Dominik_Mierzejewski Marek_Talik Mateusz_Swiszcz Michal_Smereczynski Grzegorz_Bartman Lukasz_Gawel Piotr_Koscielniak Marcin_Balda Daniel_Wicher Justyna_Ilczuk Blazej_Faliszek Lukasz_Oles).
        map { |speaker| Person.new(speaker) }
  end

  def prepare_team
    @team = %w(Dominik_Kozaczko Eunika_Tabak Dariusz_Wylon Michal_Czyz Tomasz_Gancarczyk Grzegorz_Rduch Marcin_Szalowicz Katarzyna_Jasiewicz Joanna_Walus Pawel_Rudyk Lukasz_Czulak Tomasz_Kaminski Krzysztof_Gren Andrzej_Kastelik Pawel_Krusinski Beata_Goluch Piotr_Juroszek Justyna_Jasek Michal_Krzus Janusz_Zukowicz Jan_Frindt Maciej_Kwasniak Artur_Loska Bartosz_Szczepanski Bartlomiej_Borak Marcin_Wadon).map { |speaker| Person.new(speaker) }
  end

  def prepare_talks
    @talks = [:dayone, :daytwo, :daythree].each_with_object({}) do |day, cache|
      cache[day] = I18n.t(:agenda, scope: [:schedule, day]).keys.map(&:to_s).sort.collect do |agenda_key|
        Talk.new(agenda_key, day)
      end
    end
  end
end
