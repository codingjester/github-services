require File.expand_path('../helper', __FILE__)

class TumblrTest < Service::TestCase
  def test_push
    svc = service({'token' => 't', 'secret' => 's'}, payload)
    
    def svc.post(title, url, description)
      @params = {:title => title, :url => url, :description => description}
    end
    
    svc.receive_push
    assert_equal 'test', @params['title']
  
  end
  
  def test_oauth_consumer
    svc = service({'oauth_token' => 't', 'oauth_secret' => 's'}, payload)

    svc.secrets = {'tumblr' => {'key' => 'ck', 'secret' => 'cs'}}
    assert_equal 'ck', svc.consumer_key
    assert_equal 'cs', svc.consumer_secret
    assert svc.consumer
  end

  def service(*args)
    super Service::Tumblr, *args
  end

end
