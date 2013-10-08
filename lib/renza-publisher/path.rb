class RenzaPublisher
  class Path
    require 'pathname'

    SAMPLE_DIR = "samples"
    SAMPLE_BASENAMES = %w[beginning ending_win ending_lose]
    MASKING_FILE_FORMAT = "mask%d.jpg"
    TIME_TABLE_FORMAT = "time_table_disk%d.json"
    METADATA = "metadata.json"
    IMAGE_FORMAT = "image-%04d.jpg"
    THUMBNAIL_FORMAT = "vol%03d_thumb.jpg"
    VIDEO_FORMAT_BASE = "vol%03d"
    
    attr_accessor :working_dir, :data_dir
    attr_accessor :video_extension

    def initialize(working_dir, data_dir, video_extension)
      @working_dir, @data_dir = Pathname.new(working_dir), Pathname.new(data_dir)
      [@working_dir, @data_dir].each do |dir| dir.mkpath end
      @video_extension = video_extension
    end
    
    def image_file(i)
      sprintf((@working_dir + IMAGE_FORMAT).to_s, i)
    end
    
    def video_file(i)
      sprintf((@data_dir + (VIDEO_FORMAT_BASE+@video_extension)).to_s, i)
    end
    
    def thumbnail_file(i)
      sprintf((@data_dir + THUMBNAIL_FORMAT).to_s, i)
    end

    def time_table_file(disk_number)
      sprintf((@data_dir + TIME_TABLE_FORMAT).to_s, disk_number)
    end

    def metadata_file
      (@data_dir + METADATA).to_s
    end

    def masking_file_for_beginning
      sprintf((@working_dir + MASKING_FILE_FORMAT).to_s, 1)
    end
    
    def masking_file_for_losing
      sprintf((@working_dir + MASKING_FILE_FORMAT).to_s, 2)
    end

    def sample_dir
      (@data_dir + SAMPLE_DIR).to_s
    end

    def sample_dir_include_all_samples?
      SAMPLE_BASENAMES.map{|s| s + ".jpg"}.all?{|sample|
        Dir.entries(sample_dir).include? sample
      }
    end

    def sample_basenames
      SAMPLE_BASENAMES
    end

    def sample_files
      SAMPLE_BASENAMES.map{|s| @data_dir + SAMPLE_DIR + (s + '.jpg')}.map(&:to_s)
    end      

  end
end
