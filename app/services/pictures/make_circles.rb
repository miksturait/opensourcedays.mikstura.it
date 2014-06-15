module Picture
  class MakeCircles < Struct.new(:original_dir, :dest_dir, :pattern)
    def self.for_all
      source_path = Rails.root.join('public/assets/speakers')
      dest_path = Rails.root.join('public/assets/speakers_ellipse')
      new(source_path, dest_path, /.*\.jpg/)
    end

    def process
      picture_files_list.map(&:convert)
    end

    def picture_files_list
      Dir.open(original_dir).collect { |filename| PictureFile.new(original_dir, dest_dir, filename) if filename =~ pattern }.compact
    end

    class PictureFile < Struct.new(:original_dir, :dest_dir, :filename)
      def convert
        ` convert #{original_full_path}  \\
        \\( +clone  -alpha extract \\
        -draw 'fill black polygon 0,0 0,200 200,0 fill white circle 100,100 100,1' \\
        \\( +clone -flip \\) -compose Multiply -composite \\
        \\( +clone -flop \\) -compose Multiply -composite \\
        \\) -alpha off -compose CopyOpacity -composite  #{dest_full_path}`
      end

      def original_full_path
        File.join(original_dir, filename)
      end

      def dest_full_path
        File.join(dest_dir, dest_filename)
      end

      def dest_filename
        filename.sub(/\.[^\.]+/, '.png')
      end
    end
  end
end
