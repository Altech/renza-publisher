# -*- coding: utf-8 -*-


module RenzaPublisher::ImageProcessor
  require 'RMagick'

  def self.is_same?(query_path, src_path, mask_path = "", threshold = 0.001)
    
    query = Magick::ImageList.new(query_path).first
    src = Magick::ImageList.new(src_path).first
    
    if mask_path != ""
      # マスク画像があるときには，マスクを画像に掛ける
      masks = Magick::ImageList.new(mask_path)
      masks.alpha = Magick::ActivateAlphaChannel
      mask = masks.fx("r", Magick::AlphaChannel)
      query = set_mask(query, mask)
      src = set_mask(src, mask)
    end
    
    # 明度値の正規化平均誤差がthreshold以下かどうかで一致かどうかを判断
    normalized_mean_error = query.difference(src)[1]
    if normalized_mean_error <= threshold
      return true
    else
      return false
    end
  end
  
  private
  
  # 画像に対してマスクをかけた画像を返す
  def self.set_mask(src_img_arr, mask_img)
    return mask_img.composite(src_img_arr, 0, 0, Magick::SrcInCompositeOp)
  end
  
end


