class Partner < ApiObject
  delegate :description_paragraphs,
      :id,
      :logo_url,
      :partner_group_id,
      :position,
      :social_profile_links,
      :name, to: :attributes

  def group_name
    data_source.partners_groups.find {|par_group| par_group.id == partner_group_id}.name
  end

  def self.all
    data_source.partners
  end
end