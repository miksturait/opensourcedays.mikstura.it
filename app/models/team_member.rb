class TeamMember < ApiObject
  delegate :id,
           :description_paragraphs,
           :ellipse_image_url,
           :rectangle_image_url,
           :first_name,
           :last_name,
           :title,
           :social_profile_links, to: :attributes

  def self.all
    data_source.team_members
  end
end