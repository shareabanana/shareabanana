require 'sinatra'
require 'coinbase'

class Banana < Sinatra::Application
  coinbase = Coinbase::Client.new(ENV['COINBASE_API_KEY'])

  get '/' do
    erb :index
  end

  get '/balance' do
    return coinbase.balance.to_f
  end
end

