require 'sinatra'
require 'rack-flash'
require 'nexmo'
require 'dotenv'

Dotenv.load
use Rack::Flash

enable :sessions
set :session_secret, '1a90214966e7d7ad57aef6874871ba78'
set :erb, layout: :layout

nexmo = Nexmo::Client.new

before do
  @current_user = session[:current_user]
end

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

post '/start_verification' do
  response = nexmo.start_verification(
    number: params['number'],
    brand: 'MyApp'
  )

  if response['status'] == '0'
    session[:number] = params['number']
    session[:verification_id] = response['request_id']
    redirect '/verify'
  else
    flash[:error] =  response['error_text']
    redirect '/login'
  end
end

get '/verify' do
  erb :verify
end

post '/finish_verification' do
  response = nexmo.check_verification(
    session[:verification_id],
    code: params[:code]
  )

  if response['status'] == '0'
    session[:current_user] = session[:number]
    redirect '/'
  else
    flash[:error] =  response['error_text']
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  redirect '/'
end
