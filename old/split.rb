#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'RMagick'
require 'fileutils'
require 'colorize'
require 'pry'

include FileUtils

# src: http://d.hatena.ne.jp/tehedabu/20130626/p1
class ImageProcessor
  
  # 画像のパスを指定して2画像の比較を行います．
  # マスクが指定された場合，マスクの適応後に一致をしているかどうかを返します
  # しきい値を指定して，明度値の誤差の許容割合を指定出来ます．
  # しきい値は，正規化平均誤差(0.0 - 1.0)で指定します
  # しきい値は，画像圧縮時のノイズを吸収するために使用するものとします
  # 現在では，以下のコードだとマスクをかけた領域も正規化対象となってしまいますが，
  # そのうちちゃんとしたコードに置き換えます
  def ImageProcessor.is_same?(query_path, src_path, mask_path = "", threshold = 0.001)
    
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
  def ImageProcessor.set_mask(src_img_arr, mask_img)    
    return mask_img.composite(src_img_arr, 0, 0, Magick::SrcInCompositeOp)
  end
end

src_video = "renza.m4v"

# # 1. create images
# puts "ffmpeg -i #{src_video} -r 1 -f image2 image-%04d.jpeg"
# puts `ffmpeg -i #{src_video} -r 1 -f image2 image-%04d.jpeg`

debug = false

# 2. search begin-ends.
i = 1
result = Array.new
loop do
  samples = {beginning: "image-0050.jpeg", win: "image-0203.jpeg", lose: "image-0361.jpeg"}
  candidate = "image-#{sprintf("%04d",i)}.jpeg"

  break if not File.exists? candidate
  
  if    ImageProcessor.is_same?(samples[:beginning], candidate, "mask2.jpeg")
    puts "beginning: #{candidate}".blue
    `open #{candidate}` if debug
    result << [i]
    i += 70
  elsif ImageProcessor.is_same?(samples[:win],  candidate)
    puts "win: #{candidate}".green
    `open #{candidate}` if debug
    result.last << i if result.size > 0 and result.last.size == 1
    i += 10
  elsif ImageProcessor.is_same?(samples[:lose], candidate, "mask.jpeg")
    puts "lose: #{candidate}".green
    `open #{candidate}` if debug
    # 1秒前を指定
    result.last << i-1 if result.size > 0 and result.last.size == 1
    i += 10
  else
    i += 1
  end
end

pp result

File.write("times.txt", result.pretty_inspect)

# 3. split the movie.
result.select{|a| a.size == 2}.each_with_index do |times, i|
  from, to = times
  thumbnail = "image-#{sprintf("%04d",from+5)}.jpeg"
  
  rm "game#{i+1}.m4v" if File.exists? "game#{i+1}.m4v"
  cp thumbnail, "game#{i+1}_thumbnail.jpg"
  
  puts "ffmpeg -i \"#{src_video}\" -ss #{from-3} -t #{to-from+1} \"output#{i+1}.m4v\""
  puts `ffmpeg -i "#{src_video}"   -ss #{from-3} -t #{to-from+1}  "output#{i+1}.m4v"`

end
