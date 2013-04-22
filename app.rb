require 'sinatra'
require 'coinbase'

class String
  def validate regex
    !self[regex].nil?
  end
end

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    set :quantity_regex, /^([0-9])+$/
    set :email_regex, /^([0-9][A-Z][a-z])+\@([0-9][A-Z][a-z])+\.([A-Z][a-z])+$/
  end

  get '/' do
    erb :index
  end

  post '/request' do
    unless params[:quantity].validate(settings.quantity_regex)
      @quantity_error = "Your 'quantity' field contained invalid data (#{params[:quantity]}."
    end
    unless params[:receiving].validate(settings.email_regex)
      @receiving_error = "Your 'receiving email' field contained invalid data (#{params[:receiving]})."
    end
    unless params[:sending].validate(settings.email_regex)
      @sending_error = "Your 'sending email' field contained invalid data (#{params[:sending]})."
    end
    if @quantity_error || @receiving_error || @sending_error
      erb :error
    else
      erb :request
    end
  end

  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end
end

