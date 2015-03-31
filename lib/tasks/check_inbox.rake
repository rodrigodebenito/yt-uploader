require 'pp'
LABEL_ID = 'Label_2'
task :check_inbox => :environment do
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.list,
    :parameters => {'userId' => 'me', 'labelIds' => ['INBOX', LABEL_ID]},
    :headers => {'Content-Type' => 'application/json'})
  messages = JSON.parse(result.body)['messages'] || []
		messages.each do |msg|
	  pp get_details(msg['id'])
	end
end

def get_details(id)
  client = Google::APIClient.new
  client.authorization.access_token = Token.last.fresh_token
  service = client.discovered_api('gmail')
  result = client.execute(
    :api_method => service.users.messages.get,
    :parameters => {'userId' => 'me', 'id' => id},
    :headers => {'Content-Type' => 'application/json'})
  data = JSON.parse(result.body)
 
  { subject: get_gmail_attribute(data, 'Subject'),
    from: get_gmail_attribute(data, 'From') }
end
 
def get_gmail_attribute(gmail_data, attribute)
  headers = gmail_data['payload']['headers']
  array = headers.reject { |hash| hash['name'] != attribute }
  array.first['value']
end