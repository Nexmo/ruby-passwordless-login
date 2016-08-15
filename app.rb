# web server and flash messages
require 'sinatra'
require 'rack-flash'
use Rack::Flash

# load environment variables
# from .env file
require 'dotenv'
Dotenv.load

# nexmo library
require 'nexmo'
nexmo = Nexmo::Client.new

# enable sessions and set the
# session secret
enable :sessions
set :session_secret, '123456'

# specify a default layout
set :erb, layout: :layout

# Index
# - tries to show the current
#   user's phone number if it
#   is present
#
get '/' do
  @user = session[:user]
  erb :index
end

# Login
# - presents the user with a
#   form to fill in their
#   phone number
#
get '/login' do
  erb :login
end

# Start Verification
# - starts the verification
#   process, sending a code to
#   the user's phone number
#   and then redirecting them
#   to verify the code
#
post '/start_login' do
  # start verification request
  response = nexmo.start_verification(
    number: params['number'],
    brand: 'MyApp'
  )

  # any status that's not '0'
  # is an error
  if response['status'] == '0'
    # store the number so we
    # can show it later
    session[:number] = params['number']
    # store the verification
    # ID so we can verify the
    # user's code against it
    session[:verification_id] =
      response['request_id']

    redirect '/verify'
  else
    flash[:error] =
      response['error_text']

    redirect '/login'
  end
end

# Code Verify
# - shows the user a form to
#   fill in the code they
#   received via text message
#
get '/verify' do
  erb :verify
end

# Finish Verification
# - finishes the verification
#   process, confirming the
#   user submitted code
#   against the verification ID
#
post '/finish_login' do
  # check the code with nexmo
  response = nexmo.check_verification(
    session[:verification_id],
    code: params[:code]
  )

  # any status that's not '0'
  # is an error
  if response['status'] == '0'
    # set the current user to
    # the number
    session[:user] = session[:number]

    redirect '/'
  else
    flash[:error] =
      response['error_text']

    redirect '/login'
  end
end

# Logout
# - clears the session and
#   redirects the user back to
#   the Index page
#
get '/logout' do
  session.clear
  redirect '/'
end
