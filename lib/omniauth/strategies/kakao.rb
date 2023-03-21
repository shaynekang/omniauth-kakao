require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Kakao < OmniAuth::Strategies::OAuth2
      option :name, 'kakao'

      option :client_options, {
        site: 'https://kauth.kakao.com',
        authorize_path: '/oauth/authorize',
        token_path: '/oauth/token',
        auth_scheme: :request_body
      }

      uid { raw_info['id'].to_s }

      info do
        {
          name: raw_properties['nickname'],
          image: raw_properties['profile_image'],
          thumbnail_image: raw_properties['thumbnail_image'],
          email: raw_kakao_account['email'],
          age_range: raw_kakao_account['age_range'],
          gender: raw_kakao_account['gender'],
          birthday: raw_kakao_account['birthday']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def callback_url
        if @authorization_code_from_signed_request_in_cookie
          # This fixes a redirect_uri issue. See: https://devtalk.kakao.com/t/rest-api-omniauth/19207
          ''
        else
          # callback url ignorance issue from https://github.com/intridea/omniauth-oauth2/commit/85fdbe117c2a4400d001a6368cc359d88f40abc7
          options[:callback_url] || (full_host + script_name + callback_path)
        end
      end

      private

      def raw_info
        @raw_info ||= access_token.get('https://kapi.kakao.com/v2/user/me', {}).parsed || {}
      end

      def raw_properties
        @raw_properties ||= raw_info['properties'] || {}
      end

      def raw_kakao_account
        @raw_kakao_account ||= raw_info['kakao_account'] || {}
      end
    end
  end
end
