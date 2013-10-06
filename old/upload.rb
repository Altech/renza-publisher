#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pry'

load './oauth_util.rb'

require 'google/api_client'
require 'trollop'
# require 'google/api_client/client_secrets'
# require 'google/api_client/auth/installed_app'

YOUTUBE_READ_WRITE_SCOPE = 'https://www.googleapis.com/auth/youtube'

client = Google::APIClient.new(:application_name => $0, :application_version => '1.0')
youtube = client.discovered_api('youtube', 'v3')

auth_util = CommandLineOAuthHelper.new(YOUTUBE_READ_WRITE_SCOPE)
client.authorization = auth_util.authorize()

opts = Trollop::options do
  opt :file, 'Video file to upload', :type => String
  opt :title, 'Video title', :default => 'Test Title', :type => String
  opt :description, 'Video description',
        :default => 'Test Description', :type => String
  opt :categoryId, 'Numeric video category. See https://developers.google.com/youtube/v3/docs/videoCategories/list',
        :default => 22, :type => :int
  opt :keywords, 'Video keywords, comma-separated',
        :default => '', :type => String
  opt :privacyStatus, 'Video privacy status: public, private, or unlisted',
        :default => 'public', :type => String
end

# if opts[:file].nil? or not File.file?(opts[:file])
#   Trollop::die :file, 'does not exist'
# end

opts[:file] = '/Users/Altech/Desktop/work2/output7.m4v'

# body = {
#   :snippet => {
#     :title => 'テスト2', # opts[:title],
#     :description => 'テストコメント', # opts[:description],
#     :tags => ['連ザ', '連ザ2', '対戦動画', 'アビス'], # opts[:keywords].split(','),
#     :categoryId => 20, # opts[:categoryId],
#   },
#   :status => {
#     :privacyStatus => opts[:privacyStatus]
#   }
# }

# videos_insert_response = client.execute!(
#   :api_method => youtube.videos.insert,
#   :body_object => body,
#   :media => Google::APIClient::UploadIO.new(opts[:file], 'video/*'),
#   :parameters => {
#     'uploadType' => 'multipart',
#     :part => body.keys.join(',')
#   }
#                                          )


# body = {
#   :snippet => {
#     :title => 'テスト2', # opts[:title],
#     :description => 'テストコメント', # opts[:description],
#     :tags => ['連ザ', '連ザ2', '対戦動画', 'アビス'], # opts[:keywords].split(','),
#     :categoryId => 20, # opts[:categoryId],
#   },
#   :status => {
#     :privacyStatus => opts[:privacyStatus]
#   }
# }
client.execute!(api_method: youtube.thumbnails.set, parameters: {videoId: '8lgusqdc8iU'})

res = client.execute!(api_method: youtube.thumbnails.set, parameters: {videoId: '8lgusqdc8iU', uploadType: 'resumable'})
begin
  res = client.execute!(api_method: youtube.thumbnails.set, parameters: {videoId: '8lgusqdc8iU', uploadType: 'resumable'})

  uri = URI.parse(res.headers['location'])

  require 'net/http'
  require 'net/https'
  https = Net::HTTP.new(uri.host, 443)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE
  res2 = https.post(
                    uri.path + '?' + uri.query,
                    File.read('/Users/Altech/Desktop/work2/output7_list.jpeg'),
                    {"Content-Type" => "images/jpeg"})
  binding.pry
  
  videos_insert_response =
    client.execute!(
                    :api_method => youtube.thumbnails.set,
                    :parameters => {
                      :uploadType => 'resumable',
                      :videoId => '8lgusqdc8iU'
                    })
    # client.execute!(
    #                 :api_method => youtube.thumbnails.set,
    #                 # :media => Google::APIClient::UploadIO.new('/Users/Altech/Desktop/work2/output7_list.jpeg', 'image/jpeg'),
    #                 :media => File.read('/Users/Altech/Desktop/work2/output7_list.jpeg'),
    #                 :headers => {'Content-Type' => 'image/jpeg'},
    #                 :parameters => {
    #                   :videoId => '8lgusqdc8iU'
    #                 })
  binding.pry
rescue => e
  binding.pry
end

# puts "'#{videos_insert_response.data.snippet.title}' (video id: #{videos_insert_response.data.id}) was successfully uploaded."
