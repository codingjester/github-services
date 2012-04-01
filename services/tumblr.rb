class Service::Tumblr < Service
  string :oauth_token, :oauth_secret, :blog_url
 
  def receive_push
    return unless payload['commits']
    
    repository = payload['repository']['name']
    compare_url = payload['compare']

    title = "New commits pushed to #{repository}." 
    description << "<ul>"
    payload['commits'].each do |commit|
      description << "<li><a href='#{commit['url']}'>#{commit['message']}</a></li>"
    end
    description << "</ul>"
    
    post(title, compare_url, description)

  end

  def post(title, url, description
    
    params = {:type => "link", :title => title, :url => url, :description => description}
    access_token = ::OAuth::AccessToken.new(consumer, data['oauth_token'], data['oauth_secret'])
    consumer.request(:post, "/v2/#{data['blog_url']}/post" 
                     access_token, { :scheme => :query_string }, params)
  end

  def consumer_key
    secrets['tumblr']['key']
  end

  def consumer_secret
    secrets['tumblr']['secret']
  end

  def consumer
    @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
                                        :site => "http://api.tumblr.com")
  end

end
