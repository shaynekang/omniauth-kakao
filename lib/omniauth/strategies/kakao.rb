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
        prune!({
                 'name' => raw_properties['nickname'],
                 'image' => raw_properties['thumbnail_image'],
        })
      end

      extra do
        hash = {}
        hash[:properties] = raw_properties
        prune! hash
      end

      private

      def prune!(hash)
        hash.delete_if do |_, v|
          prune!(v) if v.is_a?(Hash)
          v.nil? || (v.respond_to?(:empty?) && v.empty?)
        end
      end

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
