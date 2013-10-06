class RenzaPublisher
  module Support
    def image_file(i)
      sprintf(IMAGE_FORMAT,i)
    end
    def video_file(i)
      sprintf(VIDEO_FORMAT,i)
    end
    def thumbnail_file(i)
      sprintf(THUMBNAIL_FORMAT,i)
    end
  end
end
