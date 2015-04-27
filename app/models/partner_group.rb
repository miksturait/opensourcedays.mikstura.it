class PartnerGroup < ApiObject
  delegate :id, :name, :position, :logo_url, to: :attributes
  attr_accessor :group

  def partners
    data_source.partners.select do |partner|
      partner.partner_group_id == id && (group == partner.group_name || group == nil)
    end
  end

  def partner
    partners.first
  end



  def self.all(group=nil)
    # data_source.partners_groups.tap do |partner_group|
    #   partner_group.find { |partner_group| partner_group.name == group } if group !=nil
    # end

    if group == nil
      data_source.partners_groups.sort_by { |group| group.position }
    else
      data_source.partners_groups.find { |partner_group| partner_group.name == group }
    end
  end
end