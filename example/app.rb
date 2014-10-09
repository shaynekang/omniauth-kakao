require 'bundler/setup'
require 'sinatra'
require 'omniauth-kakao'

client_id = ENV['KAKAO_CLIENT_ID']
if client_id == nil
  class NoClientIDError < StandardError; end
  raise NoClientIDError, "KAKAO_CLIENT_ID is nil. Please run example like `KAKAO_CLIENT_ID='<your-kakako-client-id>' ruby app.rb`"
end

redirect_path = ENV['REDIRECT_PATH'] || OmniAuth::Strategies::Kakao::DEFAULT_REDIRECT_PATH

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :kakao, client_id, {:redirect_path => redirect_path}
end

helpers do
  def yaml_to_html(yaml)
    display = yaml.split("\n")
    display = display.map do |e|
      e.gsub!("  ", "&nbsp;&nbsp;&nbsp;&nbsp;")
      "<p>#{e}</p>"
    end.join
  end
end

before do
  @redirect_path = redirect_path
end

get '/' do
  erb :index
end

get '/auth/:provider/callback' do
  @modal = {
    title: "Success!",
    body: yaml_to_html(request.env['omniauth.auth'].to_yaml)
  }

  erb :index
end

get '/auth/failure' do
  @modal = {
    title: "Failure",
    body: "Error: #{params[:message]}"
  }

  erb :index
end

__END__
@@ index
<html>
  <head>
    <title>Test Application for Omniauth Kakao</title>
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
    <script src="https://code.jquery.com/jquery-2.1.0.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>
    <style>
      #login-form {
        margin-top: 30px;
        text-align: center;
      }

      #login-form.panel-primary {
        border-color: #FFEB00;
      }

      #login-form.panel-primary > .panel-heading {
        background-image: -webkit-linear-gradient(top, #FFEB00 0, #FFEB00 100%);
        background-image: -moz-linear-gradient(top, #FFEB00 0, #FFEB00 100%);
        background-image: -o-linear-gradient(top, #FFEB00 0, #FFEB00 100%);
        background-image: linear-gradient(top, #FFEB00 0, #FFEB00 100%);
        background-color: #FFEB00;
        border-color: #FFEB00;
        color: #3D1D12;
      }

      .btn-kakao {
        display: inline-block;
        background-image: url("https://kauth.kakao.com/public/widget/login/kr/kr_02_medium.png");

        width: 222px;
        height: 49px;

        line-height: 0;
        font-size: 0;
        color: transparent;
      }

      #redirect-path {
        text-align: right;
        margin: 20px 0 0 0;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="row">
        <div class="col-md-6 col-md-offset-3">
          <div id="login-form" class="panel panel-primary">
            <div class="panel-heading">
              <h3 class="panel-title">Test Application for Omniauth Kakao</h3>
            </div>

            <div class="panel-body">
              <a href="/auth/kakao" class="btn-kakao">카카오 계정으로 로그인</a>
              <p id="redirect-path"><small>Redirect Path: <%= @redirect_path %></small></p>
            </div>
          </div>
        </div>

        <% if @modal %>
          <div class="modal fade" id="auth-modal" tabindex="-1" role="dialog" aria-labelledby="auth-modal-label" aria-hidden="true">
            <div class="modal-dialog modal-lg">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                  <h4 class="modal-title" id="myModalLabel"><%= @modal[:title] %></h4>
                </div>

                <div class="modal-body">
                  <%= @modal[:body] %>
                </div>

                <div class="modal-footer">
                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
              </div>
            </div>
          </div>

          <script>
            $(function(){
              $('#auth-modal').modal('show');
            });
          </script>
        <% end %>
      </div>
    </div>
  </body>
</html>
