module Pictures
  class MixMultiplePictures < Struct.new(:paths_of_pictures, :dest_picture)
    def self.generate_to_all_talks_and_workshops
      (Workshop.all_workshops.select {|w| w.speakers.size == 2 } + Talk.all_talks.select {|w| w.speakers.size == 2 }).each do |talk|
        new(talk.speakers.map(&:avatar_url).reverse, talk.send(:image_url)).tap { |processor| processor.convert_two }
      end
    end

    def convert_two
      `convert -size 200x200 xc:white -alpha set -channel A -evaluate set 45% \\( #{next_picture} -gravity Center -crop 98x200+0+0 -repage 98x200+51+0 \\) -geometry -51x0 -composite \\( #{next_picture} -gravity Center -crop 98x200+0+0 -repage 98x200+51+0 \\) -geometry +51+0 -composite #{convert_url_to_path(dest_picture)}`
    end

    def next_picture
      convert_url_to_path(paths_of_pictures.pop)
    end

    def convert_url_to_path(url)
      url.gsub(I18n.t('domain'), Rails.root.join('public').to_s)
    end
  end
end

