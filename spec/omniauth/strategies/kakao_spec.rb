require_relative '../../spec_helper'
require 'omniauth'
require 'omniauth-kakao'

describe OmniAuth::Strategies::Kakao do
  CLIENT_ID = '<<your-client-id>>'
  CLIENT_SECRET = '<<your-secret>>'
  SERVER_NAME = 'www.example.com'

  let(:request) { double('Request', params: {}, cookies: {}, env: {}) }
  let(:app) { ->(env) { [200, env, "app"] } }
  subject(:middleware) do
    OmniAuth::Strategies::Kakao.new(app, CLIENT_ID, CLIENT_SECRET, @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) { request }
    end
  end

  def make_request(url, opts = {})
    Rack::MockRequest.env_for(url, {
      method: 'POST',
      'rack.session' => {},
      'SERVER_NAME' => SERVER_NAME,
    }.merge(opts))
  end

  describe '#client_options' do
    it 'has correct site' do
      expect(subject.client.site).to eq('https://kauth.kakao.com')
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('oauth/authorize')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('oauth/token')
    end

    describe 'overrides' do

      context 'as strings' do
        it 'should allow overriding the site' do
          @options = { client_options: { 'site' => 'https://example.com' } }
          expect(subject.client.site).to eq('https://example.com')
        end

        it 'should allow overriding the authorize_url' do
          @options = { client_options: { 'authorize_url' => 'https://example.com' } }
          expect(subject.client.options[:authorize_url]).to eq('https://example.com')
        end

        it 'should allow overriding the token_url' do
          @options = { client_options: { 'token_url' => 'https://example.com' } }
          expect(subject.client.options[:token_url]).to eq('https://example.com')
        end
      end

      context 'as symbols' do
        it 'should allow overriding the site' do
          @options = { client_options: { site: 'https://example.com' } }
          expect(subject.client.site).to eq('https://example.com')
        end

        it 'should allow overriding the authorize_url' do
          @options = { client_options: { authorize_url: 'https://example.com' } }
          expect(subject.client.options[:authorize_url]).to eq('https://example.com')
        end

        it 'should allow overriding the token_url' do
          @options = { client_options: { token_url: 'https://example.com' } }
          expect(subject.client.options[:token_url]).to eq('https://example.com')
        end
      end
    end
  end

  describe "GET /auth/kakao" do
    before do
      allow_any_instance_of(Rack::Protection::AuthenticityToken).to receive(:valid_token?).and_return(true)
    end

    it "should redirect to authorize page" do
      request = make_request('/auth/kakao')

      code, env = middleware.call(request)
      expect(code).to eq 302

      expect_url = <<~EXPECT.gsub(/(\n|\t|\s)/, '')
        https://kauth.kakao.com/oauth/authorize
          ?client_id=#{CLIENT_ID}
          &redirect_uri=http://#{SERVER_NAME}/auth/kakao/callback
          &response_type=code
        EXPECT

      actual_url = URI.decode_uri_component(env['Location'].split("&state")[0])
      expect(actual_url).to eq expect_url
    end

    it "should customize redirect path" do
      request = make_request('/auth/kakao')
      @options = { redirect_path: '/auth/kakao/callback' }

      code, env = middleware.call(request)
      expect(code).to eq 302

      expect_url = <<~EXPECT.gsub(/(\n|\t|\s)/, '')
        https://kauth.kakao.com/oauth/authorize
          ?client_id=#{CLIENT_ID}
          &redirect_uri=http://#{SERVER_NAME}/auth/kakao/callback
          &response_type=code
        EXPECT

      actual_url = URI.decode_uri_component(env['Location'].split("&state")[0])
      expect(actual_url).to eq expect_url
    end
  end

  describe "GET /auth/kakao/callback" do
    CODE = "dummy-code"
    STATE = "dummy-state"
    ACCESS_TOKEN = "dummy-access-token"
    REFRESH_TOKEN = "dummy-refresh-token"

    before do
      stub_request(:post, "https://kauth.kakao.com/oauth/token")
        .with(
          body: {
            grant_type: 'authorization_code',
            # client_id: CLIENT_ID,
            # client_secret: CLIENT_SECRET,
            redirect_uri: "http://#{SERVER_NAME}/auth/kakao/callback?code=dummy-code&state=dummy-state",
            code: CODE
          },
        ).to_return(
          headers: {
            content_type: "application/json;charset=UTF-8",
          },
          body: {
            access_token: ACCESS_TOKEN,
            token_type: "bearer",
            refresh_token: REFRESH_TOKEN,
            expires_in: 99999,
            scope: "Basic_Profile"
          }.to_json
        )

      stub_request(:get, "https://kapi.kakao.com/v2/user/me")
        .with(
          headers: {
            Authorization: "Bearer #{ACCESS_TOKEN}"
          }
        ).to_return(
          headers: {
            content_type: "application/json;charset=UTF-8",
          },
          body: {
            id: 123456789,
            properties: {
              nickname: "John Doe",
              thumbnail_image: "http://xxx.kakao.com/.../aaa.jpg",
              profile_image: "http://xxx.kakao.com/.../bbb.jpg",
            }
          }.to_json
        )
    end

    it "should request access token and user information" do
      request = make_request("/auth/kakao/callback?code=#{CODE}&state=#{STATE}", {
        'rack.session' => {
          'omniauth.state' => STATE
        },
      })

      code, env = middleware.call(request)
      expect(code).to eq 200

      response = env['omniauth.auth']
      expect(response.provider).to eq "kakao"
      expect(response.uid).to eq "123456789"

      information = response.info
      expect(information.name).to eq "John Doe"
      expect(information.image).to eq "http://xxx.kakao.com/.../bbb.jpg"
      expect(information.thumbnail_image).to eq "http://xxx.kakao.com/.../aaa.jpg"

      credentials = response.credentials
      expect(credentials.token).to eq ACCESS_TOKEN
      expect(credentials.refresh_token).to eq REFRESH_TOKEN

      properties = response.extra.raw_info.properties
      expect(properties.nickname).to eq "John Doe"
      expect(properties.thumbnail_image).to eq "http://xxx.kakao.com/.../aaa.jpg"
      expect(properties.profile_image).to eq "http://xxx.kakao.com/.../bbb.jpg"
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

    describe "GET /auth/kakao/callback" do
      it "should request registered mock" do
        request = make_request("/auth/kakao/callback")
        code, env = middleware.call(request)
        expect(code).to eq 200

        response = env["omniauth.auth"]
        expect(response.provider).to eq "kakao"
        expect(response.uid).to eq "123456789"

        information = response.info
        expect(information.name).to eq "John Doe"
        expect(information.image).to eq "http://xxx.kakao.com/.../aaa.jpg"
      end
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end
end
