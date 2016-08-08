require 'spec_helper'
require 'omniauth'
require 'omniauth-kakao'

describe OmniAuth::Strategies::Kakao do
  CLIENT_ID = '<<your-client-id>>'
  SERVER_NAME = 'www.example.com'

  before do
    OmniAuth.config.logger.level = 5
  end

  def make_middleware(client_id, opts={})
    app = ->(env) { [200, env, "app"] }

    middleware = OmniAuth::Strategies::Kakao.new(app, opts)
    middleware.tap do |middleware|
      middleware.options.client_id = client_id
    end
  end

  def make_request(url, opts={})
    Rack::MockRequest.env_for(url, {
      'rack.session' => {},
      'SERVER_NAME' => SERVER_NAME,
    }.merge(opts))
  end

  describe "GET /auth/kakao" do
    it "should redirect to authorize page" do
      request = make_request('/auth/kakao')
      middleware = make_middleware(CLIENT_ID)

      code, env = middleware.call(request)

      code.should == 302

      expect_url = <<-EXPECT
        https://kauth.kakao.com/oauth/authorize
          ?client_id=#{CLIENT_ID}
          &redirect_uri=http://#{SERVER_NAME}/oauth
          &response_type=code
        EXPECT
        .gsub(/(\n|\t|\s)/, '')

      actual_url = URI.decode(env['Location'].split("&state")[0])

      actual_url.should == expect_url
    end

    it "should customize redirect path" do
      request = make_request('/auth/kakao')
      middleware = make_middleware(CLIENT_ID, redirect_path: '/auth/kakao/callback')

      code, env = middleware.call(request)

      code.should == 302

      expect_url = <<-EXPECT
        https://kauth.kakao.com/oauth/authorize
          ?client_id=#{CLIENT_ID}
          &redirect_uri=http://#{SERVER_NAME}/auth/kakao/callback
          &response_type=code
        EXPECT
        .gsub(/(\n|\t|\s)/, '')

      actual_url = URI.decode(env['Location'].split("&state")[0])

      actual_url.should == expect_url
    end
  end

  describe "GET /oauth" do
    CODE = "dummy-code"
    STATE = "dummy-state"
    ACCESS_TOKEN = "dummy-access-token"
    REFRESH_TOKEN = "dummy-refresh-token"

    before do
      FakeWeb.register_uri(:post, "https://kauth.kakao.com/oauth/token",
        :content_type => "application/json;charset=UTF-8",
        :parameters => {
          :grant_type => 'authorization_code',
          :client_id => CLIENT_ID,
          :redirect_uri => URI.encode("http://#{SERVER_NAME}/oauth"),
          :code => CODE
        },
        :body => {
          :access_token => ACCESS_TOKEN,
          :token_type => "bearer",
          :refresh_token => REFRESH_TOKEN,
          :expires_in => 99999,
          :scope => "Basic_Profile"
        }.to_json
      )

      FakeWeb.register_uri(:get, "https://kapi.kakao.com/v1/user/me",
        :content_type => "application/json;charset=UTF-8",
        :"Authorization" => "Bearer #{ACCESS_TOKEN}",
        :body => {
          :id => 123456789,
          :properties => {
            :nickname => "John Doe",
            :thumbnail_image => "http://xxx.kakao.com/.../aaa.jpg",
            :profile_image => "http://xxx.kakao.com/.../bbb.jpg",
          }
        }.to_json
      )
    end

    it "should request access token and user information" do
      request = make_request("/oauth?code=#{CODE}&state=#{STATE}", {
        'rack.session' => {
          'omniauth.state' => STATE
        },
      })

      middleware = make_middleware(CLIENT_ID)

      code, env = middleware.call(request)

      code.should == 200

      response = env['omniauth.auth']

      response.provider.should == "kakao"
      response.uid.should == "123456789"

      information = response.info
      information.name.should == "John Doe"
      information.image.should == "http://xxx.kakao.com/.../aaa.jpg"

      credentials = response.credentials
      credentials.token.should == ACCESS_TOKEN
      credentials.refresh_token.should == REFRESH_TOKEN

      properties = response.extra.properties
      properties.nickname.should == "John Doe"
      properties.thumbnail_image.should == "http://xxx.kakao.com/.../aaa.jpg"
      properties.profile_image.should == "http://xxx.kakao.com/.../bbb.jpg"
    end
  end

  context "test environment" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:kakao, {
        provider: "kakao",
        uid: "123456789",
        info: {
          name: "John Doe",
          image: "http://xxx.kakao.com/.../aaa.jpg"
        }
      })
    end

    describe "GET /auth/kakao" do
      it "should redirect to callback url (/auth/kakao/callback)" do
        request = make_request("/auth/kakao")
        middleware = make_middleware(CLIENT_ID)
        code, env = middleware.call(request)

        code.should == 302

        actual_path = URI(env["Location"]).path
        actual_path.should == "/auth/kakao/callback"
      end
    end

    describe "GET /oauth" do
      it "should request registered mock" do
        request = make_request("/oauth")
        middleware = make_middleware(CLIENT_ID)
        code, env = middleware.call(request)

        code.should == 200

        response = env["omniauth.auth"]

        response.provider.should == "kakao"
        response.uid.should == "123456789"

        information = response.info
        information.name.should == "John Doe"
        information.image.should == "http://xxx.kakao.com/.../aaa.jpg"
      end
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end
end
