class SessionsController < ApplicationController
  layout false

  def new
  end

  def create
    @auth = request.env['omniauth.auth']['credentials']
    Token.create(
    	access_token: @auth['token'],
    	refresh_token: @auth['refresh_token'],
    	expires_at: Time.at(@auth['expires_at']).to_datetime )
  end

  def upload
    uploaded = params[:video]
    File.open(Rails.root.join('tmp', 'uploads', uploaded.original_filename), 'wb') do |file|
      file.write(uploaded.read)
      filename = "tmp/uploads/#{uploaded.original_filename}"
      @youtube = Youtube.new(Token.last.fresh_token)
      @response = JSON.parse @youtube.upload(filename).body
    end
  end

end

=begin

Sample youtube.upload response:
{
  "kind" = > "youtube#video", 
  "etag" = > "\"9iWEWaGPvvCMMVNTPHF9GiusHJA/iWweEyBpQ3UZKHlcDTKty4zUQf0\"", 
  "id" = > "7AaoCyd4CYk", 
  "snippet" = > {
    "publishedAt" = > "2015-03-31T16:36:30.000Z", 
    "channelId" = > "UCszD2X8AuRUDWIOjE0G-6YQ", 
    "title" = > "Upload Test Title", 
    "description" = > "Upload Test Description", 
    "thumbnails" = > {
      "default" = > {
        "url" = > "https://i.ytimg.com/vi/7AaoCyd4CYk/default.jpg", "width" = > 120, "height" = > 90
      }, "medium" = > {
        "url" = > "https://i.ytimg.com/vi/7AaoCyd4CYk/mqdefault.jpg", "width" = > 320, "height" = > 180
      }, "high" = > {
        "url" = > "https://i.ytimg.com/vi/7AaoCyd4CYk/hqdefault.jpg", "width" = > 480, "height" = > 360
      }
    }, 
    "channelTitle" = > "Rodrigo De Benito Sanz", 
    "categoryId" = > "22", 
    "liveBroadcastContent" = > "none", 
    "localized" = > {
      "title" = > "Upload Test Title", 
      "description" = > "Upload Test Description"
    }
  }, "status" = > {
    "uploadStatus" = > "uploaded", 
    "privacyStatus" = > "unlisted", 
    "license" = > "youtube", 
    "embeddable" = > true, 
    "publicStatsViewable" = > true
  }
}

=end