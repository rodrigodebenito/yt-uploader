# https://gist.github.com/philnash/35bd1dfa4cebb9328888

class YouTube
  # Don't generate the token in the initializer, pass it in.
  # No need for attr_accessor on the client or service either, just save them as 
  # instance variables.
  def initialize(token)
    @client = Google::APIClient.new
    @client.authorization.access_token = token
    @service = @client.discovered_api('youtube', 'v3')
  end
 
  DEFAULT_OPTIONS = {
    #:parameters => {
    #  'userId' => 'me'
    #},
    :headers => { 'Content-Type' => 'application/json' }
  }

  def upload(file)
  	if file.nil? or not File.file?(file) then
	  	puts "FILE DOESN'T EXIST!"
	  else
	  	opts = DEFAULT_OPTIONS.merge(:api_method => @youtube.videos.insert)
	  	opts[:body_object] = body
	  	opts[:media] = Google::APIClient::UploadIO.new(file, 'video/*')
	  	opts[:parameters] = {
    		'uploadType' => 'multipart',
    		'part' => body.tags.join(',')
  		}
  		response = execute(opts)
  		puts "'#{response.data.snippet.title}' (video id: #{response.data.id}) was successfully uploaded."
	  end
  end

  private
 
  def execute(opts)
    @client.execute opts 
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
		    :privacyStatus => 'private' # Video privacy status: public, private, or unlisted
		  }
		}
	end
end