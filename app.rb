require 'sinatra'
require 'coinbase'

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
  end

  get '/' do
    erb :index
  end

  get '/balance' do
    return settings.coinbase.balance.to_f
  end
end

