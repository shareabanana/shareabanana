require 'sinatra'
require 'coinbase'
require 'pony'
require 'rack/recaptcha'
require 'redis'

=begin
COINBASE_API_KEY
RECAPTCHA_PUBLIC
RECAPTCHA_PRIVATE
SENDGRID_USERNAME
SENDGRID_PASSWORD
REDISCLOUD_URL
=end

class String
  def validate regex
    !self[regex].nil?
  end
end

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    set :email_regex, /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/

    uri = URI.parse ENV['REDISCLOUD_URL']
    @redis = Redis.new :host => uri.host, :port => uri.port, :password => uri.password

    use Rack::Recaptcha, :public_key => ENV['RECAPTCHA_PUBLIC'], :private_key => ENV['RECAPTCHA_PRIVATE']
    helpers Rack::Recaptcha::Helpers
  end
  
  helpers do    
    def banana_email sender_address, sender_name, receiver_address
      @banana = File.basename Dir.glob('public/img/bananas/*').sample
      body = erb(:banana_email, :layout => false)
      
      Pony.mail({
                  :to => receiver_address,
                  :from => 'delivery@shareabanana.com',
                  :subject => "You have received a banana from #{sender_name}!",
                  :html_body => body,
                  :reply_to => sender_address,
                  :via => :smtp,
                  :via_options => {
                    :address => 'smtp.sendgrid.net',
                    :port => '587',
                    :domain => 'heroku.com',
                    :authentication => :plain,
                    :user_name => ENV['SENDGRID_USERNAME'],
                    :password => ENV['SENDGRID_PASSWORD'],
                    :enable_starttls_auto => true
                  }
                })
    end
  end
  
  get '/' do
    erb :index
  end

  post '/request' do
    unless params[:receiving_address].validate(settings.email_regex)
      @receiving_error = "Your 'receiving email' field contained invalid data (#{params[:receiving_address]})."
    end

    unless params[:sending_address].validate(settings.email_regex)
      @sending_error = "Your 'sending email' field contained invalid data (#{params[:sending_address]})."
    end
    
    unless recaptcha_valid?
      @recaptcha_error = "You don't appear to be a human."
    end
    
    if @receiving_error || @sending_error || @recaptcha_error
      erb :error
    else
      banana_email params[:sending_address], params[:sending_name], params[:receiving_address]
      erb :request
    end
  end
  
  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end
end

