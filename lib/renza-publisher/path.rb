class RenzaPublisher
  class Path
    require 'pathname'

    SAMPLE_DIR_FORMAT = "samples_%s_disk%d"
    SAMPLE_BASENAMES = %w[beginning ending_win ending_lose]
    MASKING_FILE_FORMAT = "mask%d.jpg"
    TIME_TABLE_FORMAT = "time_table_%s_disk%d.json"
    METADATA = "metadata.json"
    IMAGE_FORMAT = "image-%04d.jpg"
    THUMBNAIL_FORMAT = "vol%03d__.jpg"
    VIDEO_FORMAT_BASE = "vol%03d_%s"
    
    attr_accessor :working_dir, :data_dir
    attr_accessor :video_extension
    attr_accessor :disk_number

    def initialize(working_dir, data_dir, video_extension, disk_number, seat)
      @working_dir, @data_dir = Pathname.new(working_dir), Pathname.new(data_dir)
      [@working_dir, @data_dir].each do |dir| dir.mkpath end
      @video_extension = video_extension
      @disk_number = disk_number
      @seat = seat
    end
    
    def image_file(i)
      sprintf((@working_dir + IMAGE_FORMAT).to_s, i)
    end
    
    def video_file(i)
      sprintf((@data_dir + (VIDEO_FORMAT_BASE+@video_extension)).to_s, i, @seat)
    end
    
    def thumbnail_file(i, suffix = nil)
      dir = suffix.nil? ? @data_dir : @data_dir + 'thumbnails'
      p = sprintf((dir + THUMBNAIL_FORMAT).to_s, i)
      if suffix.nil? 
        p
      else
        add_suffix p, suffix
      end
    end

    def time_table_file(seat = @seat, disk_number = @disk_number)
      sprintf((@data_dir + TIME_TABLE_FORMAT).to_s, seat, disk_number)
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
      sprintf((@working_dir +  SAMPLE_DIR_FORMAT).to_s, @seat, @disk_number)
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
      SAMPLE_BASENAMES.map{|s| sample_dir + '/' + s + '.jpg'}
    end

    def add_suffix(path, suffix)
      path = Pathname.new(path)
      new_path = path.dirname + (path.basename.to_s[/(.+)(\..+)/,1] + "_" + suffix +  path.basename.to_s[/(.+)(\..+)/,2])
      new_path.to_s
    end
    
  end
end
