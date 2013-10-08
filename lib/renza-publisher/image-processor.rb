# -*- coding: utf-8 -*-


module RenzaPublisher::ImageProcessor
  require 'RMagick'

  def self.is_same?(query_path, src_path, mask_path = "", threshold = 0.001)
    query = Magick::ImageList.new(query_path).first
    src = Magick::ImageList.new(src_path).first
    
    if mask_path != ""
      masks = Magick::ImageList.new(mask_path)
      masks.alpha = Magick::ActivateAlphaChannel
      mask = masks.fx("r", Magick::AlphaChannel)
      query = set_mask(query, mask)
      src = set_mask(src, mask)
    end

    normalized_mean_error = query.difference(src)[1]
    result = normalized_mean_error <= threshold
    
    # explicitly free memory
    [query, src, mask].each do |img| img.destroy! if img end

    return result
  end

  def self.create_images_for_masking(path)
    img = Magick::ImageList.new(path.image_file(1)).first
    width, height = img.columns, img.rows

    %w[beginning losing].each_with_index do |s,i|
      mask = Magick::Image.new(width, height){
        self.background_color = "white"
      }
      idr = Magick::Draw.new
      idr.fill = "#000000"
      case s
      when 'beginning'
        idr.rectangle(0, (height*0.78).to_i, width-1, height-1)
      when 'losing'
        idr.rectangle(0, 0, width-1, (height*0.38).to_i)
        idr.rectangle(0, (height*0.61).to_i, width-1, height-1)
      else
        require 'pry'
        binding.pry
      end
      idr.draw(mask)
      mask.write(path.send("masking_file_for_#{s}"))
    end
  end
  
  private
  
  # return masked image
  def self.set_mask(src_img_arr, mask_img)
    return mask_img.composite(src_img_arr, 0, 0, Magick::SrcInCompositeOp)
  end
  
end


