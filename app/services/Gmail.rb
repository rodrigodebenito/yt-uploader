# https://gist.github.com/philnash/35bd1dfa4cebb9328888

class Gmail
  # Don't generate the token in the initializer, pass it in.
  # No need for attr_accessor on the client or service either, just save them as 
  # instance variables.
  def initialize(token)
    @client = Google::APIClient.new
    @client.authorization.access_token = token
    @service = @client.discovered_api('gmail')
  end
 
  DEFAULT_OPTIONS = {
    :parameters => {
      'userId' => 'me'
    },
    :headers => { 'Content-Type' => 'application/json' }
  }
 
  def labels
    opts = DEFAULT_OPTIONS.merge(:api_method => @service.users.labels.list)
    execute(opts)
  end
 
  def messages_for_label(label_id)
    opts = DEFAULT_OPTIONS.merge(:api_method => @service.users.messages.list)
    opts[:parameters]['labelIds'] = ['INBOX', label_id]
    execute(opts)
  end
 
  def message_details(message_id)
    opts = DEFAULT_OPTIONS.merge(:api_method => @service.users.messages.get)
    opts[:parameters]['id'] = message_id
    execute(opts)
  end
 
  def remove_label(message_id, label_id)
    opts = DEFAULT_OPTIONS.merge(:api_method => @service.users.messages.modify)
    opts[:parameters]['id'] = message_id
    opts[:body_object]['removeLabelIds'] = [label_id]
    execute(opts)
  end
 
  private
 
  def execute(opts)
    @client.execute opts 
  end
end