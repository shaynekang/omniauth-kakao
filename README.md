# OmniAuth Kakao

This is the OmniAuth strategy for authenticating to [Kakao](http://www.kakao.com/). To
use it, you'll need to sign up for an REST API Key on the [Kakao Developers Page](http://developers.kakao.com). For more information, please refer to [Create New Application](https://developers.kakao.com/docs/restapi#시작하기-앱-생성) page.

[카카오](http://www.kakao.com/) 인증을 위한 OmniAuth strategy 입니다. [카카오 개발자 페이지](http://developers.kakao.com)에서 REST API 키를 생성한 뒤 이용해 주세요. 자세한 사항은 [시작하기 - 앱 생성](https://developers.kakao.com/docs/restapi#시작하기-앱-생성) 페이지를 참고하시기 바랍니다.

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

다음은 간단한 예제입니다. `config/initializers/omniauth.rb`에서 미들웨어(Middleware)를 레일즈 어플리케이션에 넣어주세요.


```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :kakao, ENV['KAKAO_CLIENT_ID']
end
```

Then go to [My Application](https://developers.kakao.com/apps) page, select your current application and add your domain address(ex: http://localhost:3000/) to  'Setting - Platform - Web - Site Domain'.

그리고 [내 어플리케이션](https://developers.kakao.com/apps)에서 현재 어플리케이션을 선택하고, '설정 - 플랫폼 - 웹 - 사이트 도메인'에  도메인 주소(예: http://localhost:3000/)를 넣어주세요.

![이미지](https://developers.kakao.com/assets/images/dashboard/dev_011.png)

For more information, please read the [OmniAuth](https://github.com/intridea/omniauth) docs for detailed instructions.

더 자세한 사항은 [OmniAuth](https://github.com/intridea/omniauth)의 문서를 참고해 주세요.

## Example

You can test omniauth-kakao in the `example/` folder.

`example/` 폴더에 있는 예제를 통해 omniauth-kakao를 테스트해볼 수 있습니다.

```
cd example/
bundle install
KAKAO_CLIENT_ID='<your-kakako-client-id>' ruby app.rb
```

Then open `http://localhost:4567/` in your browser.

이후 `http://localhost:4567/`로 접속하시면 됩니다.

Warning: Do not forgot to add `http://localhost:4567/` in [My Application](https://developers.kakao.com/apps).

주의: [내 어플리케이션](https://developers.kakao.com/apps) 의 '설정된 플랫폼 - 웹 - 사이트 도메인'에 `http://localhost:4567/`을 넣는 걸 잊지 마세요.

## Auth Hash

Here's an example *Auth Hash* available in `request.env['omniauth.auth']`:

`request.env['omniauth.auth']` 안에 들어있는 *Auth Hash* 는 다음과 같습니다.

```ruby
{
  provider: kakao                                                                                                                                                                       │127.0.0.1 - - [01/Aug/2014 16:36:35] "GET /faye HTTP/1.1" HIJACKED -1 0.0006
  uid: '1656831'                                                                                                                                                                        │127.0.0.1 - - [01/Aug/2014 16:36:35] "GET /faye?message=%5B%7B%22channel%22%3A%22%2Fmeta%2Fhandshake%22%2C%22version%22%3A%221.0%22%2C%22supportedConnectionTypes%22%3A%5B%22callback
  info: !ruby/hash:OmniAuth::AuthHash::InfoHash                                                                                                                                         │-polling%22%5D%2C%22id%22%3A%221%22%7D%5D&jsonp=__jsonp1__ HTTP/1.1" HIJACKED -1 0.0004
    name: "김수림"                                                                                                                                                                      │127.0.0.1 - - [01/Aug/2014 16:37:27] "GET /faye?message=%5B%7B%22channel%22%3A%22%2Fmeta%2Fhandshake%22%2C%22version%22%3A%221.0%22%2C%22supportedConnectionTypes%22%3A%5B%22callback
    thumbnail_image: http://mud-kage.kakao.co.kr/14/dn/btqbrEZH0uH/YJAsXaWawNtQ32gwIhdgW0/o.jpg                                                                                         │-polling%22%5D%2C%22id%22%3A%221%22%7D%5D&jsonp=__jsonp1__ HTTP/1.1" HIJACKED -1 0.0003
    profile_image: http://mud-kage.kakao.co.kr/14/dn/btqbrCnh7kj/5rkkAq6GASCd1hHhkIxKbK/o.jpg                                                                                           │127.0.0.1 - - [01/Aug/2014 16:37:28] "GET /faye HTTP/1.1" HIJACKED -1 0.0009
  credentials: !ruby/hash:OmniAuth::AuthHash                                                                                                                                            │127.0.0.1 - - [01/Aug/2014 16:37:44] "GET /faye HTTP/1.1" HIJACKED -1 0.0007
    token: tneJoAkZy1RG2TCFK2E8TzWRaDZrIqmKzIr11KwQQjMAAAFHkOPavQ                                                                                                                       │127.0.0.1 - - [01/Aug/2014 16:37:44] "GET /faye?message=%5B%7B%22channel%22%3A%22%2Fmeta%2Fhandshake%22%2C%22version%22%3A%221.0%22%2C%22supportedConnectionTypes%22%3A%5B%22callback
    refresh_token: FZdBEjbuJDebaEbilBM992eGShfiZM5rkevTL6wQQjMAAAFHkOPavg                                                                                                               │-polling%22%5D%2C%22id%22%3A%221%22%7D%5D&jsonp=__jsonp1__ HTTP/1.1" HIJACKED -1 0.0003
    expires_at: 1406906907                                                                                                                                                              │127.0.0.1 - - [01/Aug/2014 16:37:46] "POST /faye HTTP/1.1" HIJACKED -1 0.0005
    expires: true                                                                                                                                                                       │127.0.0.1 - - [01/Aug/2014 16:43:08] "GET /faye HTTP/1.1" HIJACKED -1 0.0006
  extra: !ruby/hash:OmniAuth::AuthHash                                                                                                                                                  │127.0.0.1 - - [01/Aug/2014 16:43:08] "GET /faye?message=%5B%7B%22channel%22%3A%22%2Fmeta%2Fhandshake%22%2C%22version%22%3A%221.0%22%2C%22supportedConnectionTypes%22%3A%5B%22callback
    raw_info: !ruby/hash:OmniAuth::AuthHash                                                                                                                                             │-polling%22%5D%2C%22id%22%3A%221%22%7D%5D&jsonp=__jsonp1__ HTTP/1.1" HIJACKED -1 0.0007
      id: 1656831                                                                                                                                                                       │127.0.0.1 - - [01/Aug/2014 16:43:35] "GET /faye HTTP/1.1" HIJACKED -1 0.0004
      properties: !ruby/hash:OmniAuth::AuthHash                                                                                                                                         │127.0.0.1 - - [01/Aug/2014 16:43:35] "GET /faye?message=%5B%7B%22channel%22%3A%22%2Fmeta%2Fhandshake%22%2C%22version%22%3A%221.0%22%2C%22supportedConnectionTypes%22%3A%5B%22callback
        nickname: "김수림"                                                                                                                                                              │-polling%22%5D%2C%22id%22%3A%221%22%7D%5D&jsonp=__jsonp1__ HTTP/1.1" HIJACKED -1 0.0003
        thumbnail_image: http://mud-kage.kakao.co.kr/14/dn/btqbrEZH0uH/YJAsXaWawNtQ32gwIhdgW0/o.jpg                                                                                     │127.0.0.1 - - [01/Aug/2014 16:46:31] "GET /faye HTTP/1.1" HIJACKED -1 0.0005
        profile_image: http://mud-kage.kakao.co.kr/14/dn/btqbrCnh7kj/5rkkAq6GASCd1hHhkIxKbK/o.jpg
```

## Contribute

1. Fork the repository.
1. Create a new branch for each feature or improvement.
1. Add tests for it. This is important!
1. Send a pull request from each feature branch.

***

1. 저장소를 Fork해 주세요.
1. 새로운 기능(또는 개선할 부분)마다 브랜치를 만들어 주세요.
1. 테스트를 작성해주세요. 이는 매우 중요합니다!
1. 브랜치를 pull request로 보내주세요.


## License

Copyright (c) 2014 [Shayne Sung-Hee Kang](http://medium.com/@shaynekang).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
