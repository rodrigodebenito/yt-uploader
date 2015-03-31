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
    @youtube = YouTube.new(Token.last.fresh_token)
    file = File.
    @response = JSON.parse(@youtube.upload())
  end

end