require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2
      option :name, 'kakao'

      option :client_options, {
        :site => 'https://kauth.kakao.com',
        :authorize_path => '/oauth/authorize',
        :token_url => '/oauth/token',
      }

      uid { raw_info['id'].to_s }

      info do
        {
          'nickname' => raw_properties['nickname'],
          'image' => raw_properties['thumbnail_image'],
        }
      end

      extra do
        {'properties' => raw_properties}
      end

      def initialize(app, *args, &block)
        super
        options[:callback_path] = "/oauth"
      end

      def callback_phase
        @env["PATH_INFO"] = "/auth/kakao/callback"
        super
      end

    private
      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v1/user/me', {}).parsed || {}
      end

      def raw_properties
        @raw_properties ||= raw_info['properties']
      end
    end
  end
end

OmniAuth.config.add_camelization 'kakao', 'Kakao'
