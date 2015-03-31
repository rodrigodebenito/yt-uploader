# https://gist.github.com/philnash/35bd1dfa4cebb9328888

class Youtube
  # Don't generate the token in the initializer, pass it in.
  # No need for attr_accessor on the client or service either, just save them as 
  # instance variables.
  def initialize(token)
    @client = Google::APIClient.new(:application_name => 'YouTubeUploder', :application_version => '1.0')
    @youtube = @client.discovered_api('youtube', 'v3')
    @client.authorization.access_token = token
    #auth_util = CommandLineOAuthHelper.new('https://www.googleapis.com/auth/youtube.upload')
    #@client.authorization = auth_util.authorize()
  end

  DEFAULT_OPTIONS = {}

  def upload(file)
  	if file.nil? or not File.file?(file) then
	  	puts "FILE DOESN'T EXIST!"
	  else
      puts file
	  	opts = DEFAULT_OPTIONS.merge(:api_method => @youtube.videos.insert)
	  	opts[:body_object] = body
	  	opts[:media] = Google::APIClient::UploadIO.new(file, 'video/*')
	  	opts[:parameters] = {
    		'uploadType' => 'multipart', #'multipart', 'resumable'
    		:part => body.keys.join(',')
  		}
  		result = execute(opts)
      # For resumable streams use
      #upload = result.resumable_upload
	    #if upload.resumable?
      #  execute(upload)
      #end
      result
    end
  end

  private
 
  def execute(opts)
    @client.execute!(opts)
  end

  def body
  	{
		  :snippet => {
		    :title => 'Upload Test Title',
		    :description => 'Upload Test Description',
		    :tags => [], # String Array Keywords
		    :categoryId => 22, # See https://developers.google.com/youtube/v3/docs/videoCategories/list'
		  },
		  :status => {
		    :privacyStatus => 'unlisted' # Video privacy status: public, private, or unlisted
		  }
		}
	end

end