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
          'name' => raw_properties['nickname'],
          'image' => raw_properties['profile_image'],
        }
      end

      extra do
        {:raw_info => raw_info}
      end


      private

      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v1/user/me').parsed
      end

      def raw_properties
        @raw_properties ||= raw_info['properties']
      end
    end
  end
end

OmniAuth.config.add_camelization 'kakao', 'Kakao'
