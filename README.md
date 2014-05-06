# OmniAuth Kakao

This is the OmniAuth strategy for authenticating to [Kakao](http://www.kakao.com/). To
use it, you'll need to sign up for an REST API Key on the [Kakao Developers Page](http://developers.kakao.com). For more information, please refer to [Create New Application](https://developers.kakao.com/docs/restapi#시작하기-앱-생성) page.

[카카오](http://www.kakao.com/) 인증을 위한 OmniAuth strategy 입니다. [카카오 개발자 페이지](http://developers.kakao.com)에서 REST API 키를 생성한 뒤 이용해 주세요. 자세한 내용은 [시작하기 - 앱 생성](https://developers.kakao.com/docs/restapi#시작하기-앱-생성) 페이지를 참조하시기 바랍니다.

## Installing

Add to your `Gemfile`:

`Gemfile`에 다음의 코드를 넣어주세요.

```ruby
gem 'omniauth-kakao'
```

Then `bundle install`.

이후 `bundle install` 을 실행해 주세요.

## Usage

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

다음은 간단한 예제입니다. `config/initializers/omniauth.rb`에서 미들웨어를 레일즈 어플리케이션에 넣어주세요.


```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao, ENV['KAKAO_CLIENT_ID']
end
```

For more information, please read the [OmniAuth](https://github.com/intridea/omniauth) docs for detailed instructions.

자세한 내용은 [OmniAuth](https://github.com/intridea/omniauth)의 문서를 참고해 주세요.

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

`request.env['omniauth.auth']` 안에 들어있는 *Auth Hash* 는 다음과 같습니다.

```ruby
{
  :provider => 'kakao',
  :uid => '123456789',
  :info => {
    :name => 'Hong Gil-Dong',
    :image => 'http://xxx.kakao.com/.../aaa.jpg',
  },
  :credentials => {
    :token => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store.
    :refresh_token => 'OPQRST...', # OAuth 2.0 refresh_token.
    :expires_at => 1321747205, # when the access token expires (it always will)
    :expires => true # this will always be true
  },
  :extra => {
    :properties => {
      :nickname => 'Hong Gil-Dong',
      :thumbnail_image => 'http://xxx.kakao.com/.../aaa.jpg'
      :profile_image => 'http://xxx.kakao.com/.../bbb.jpg'
    }
  }
}
```

## Contribute

1. Fork the repository.
1. Create a new branch for each feature or improvement.
1. Add tests for it. This is important!
1. Send a pull request from each feature branch.

***

1. 저장소를 Fork해 주세요.
1. 각각의 신 기능(또는 개선할 부분)마다 새로운 브랜치를 만들어 주세요.
1. 테스트를 작성해주세요. 이는 매우 중요합니다!
1. 기능 브랜치를 pull request로 보내주세요.


## License

Copyright (c) 2014 [Shayne Sung-Hee Kang](http://medium.com/@shaynekang).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
