# Passwordless Login with Nexmo Verify

A Sinatra (Ruby) app showing how to implement passwordless login and registration using the Nexmo Verify API.

## Prerequisites

* [A Nexmo account](https://dashboard.nexmo.com/sign-up)
* [Ruby 2.1+](https://www.ruby-lang.org/) and [Bundler](http://bundler.io/)

## Getting started

```sh
# clone this repository
git clone git@github.com:Nexmo/ruby-passwordless-login.git
# change to folder
cd ruby-passwordless-login
# install dependencies
bundle install
# create a .env
cp .env.example .env
```

Next you will need to sign up for a Nexmo account and get your API credentials from the API dashboard and put them in your `.env`
file.

Finally all that's left is to start the server.

```sh
ruby app.rb
```

## Usage

This app shows you how to login a user using [Sinatra](http://www.sinatrarb.com/), Ruby and [Nexmo Verify](https://www.nexmo.com/products/verify/).

Once your server is started:

* Visit [localhost:4567](http://localhost:4567/)
* Click `Login`
* Fill in your phone number without any leading 0's or +'s (e.g. `445555666777`)
* You will receive a code in seconds, fill this in on the second form and submit
* You will now be logged in

As this is a very simple starter app this app does not do any user verification against a database. It does show you how to ensure the verification was a success and how to catch any errors that may occur when trying to create or verify a verification request.

## License

This project is licensed under the [MIT license](LICENSE).
