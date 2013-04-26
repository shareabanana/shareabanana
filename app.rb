require 'sinatra'
require 'coinbase'
require './mailer'
 
class String
  def validate regex
    !self[regex].nil?
  end
end

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    set :email_regex, /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/
  end

  get '/' do
    erb :index
  end

  post '/request' do
    unless params[:receiving].validate(settings.email_regex)
      @receiving_error = "Your 'receiving email' field contained invalid data (#{params[:receiving]})."
    end
    unless params[:sending].validate(settings.email_regex)
      @sending_error = "Your 'sending email' field contained invalid data (#{params[:sending]})."
    end
    if @receiving_error || @sending_error
      erb :error
    else
      #      generate_conf_link params[:receiving], params[:sending]

      BananaMailer.deliver_banana_email params[:receiving], params[:sending]#, conf_link
      erb :request
    end
  end

  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end
end

