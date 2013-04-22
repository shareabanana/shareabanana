require 'sinatra'
require 'coinbase'

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end

  get '/' do
    erb :index
  end

  post '/request' do
    unless params['quantity'].validate(/^[0-9]$/)
      erb :error
    end
    erb :request
  end

  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end
end

