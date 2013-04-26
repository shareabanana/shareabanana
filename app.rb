require 'sinatra'
require 'coinbase'
require 'pony'
require 'rack/recaptcha'

class String
  def validate regex
    !self[regex].nil?
  end
end

class Banana < Sinatra::Application
  configure do
    set :coinbase, Coinbase::Client.new(ENV['COINBASE_API_KEY'])
    set :email_regex, /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/

    use Rack::Recaptcha, :public_key => ENV['RECAPTCHA_PUBLIC'], :private_key => ENV['RECAPTCHA_PRIVATE']
    helpers Rack::Recaptcha::Helpers
  end

  helpers do    
    def banana_email sender, receiver
      @banana = File.basename Dir.glob('public/img/bananas/*').sample
      body = erb(:banana_email, :layout => false)
      
      Pony.mail({
                  :to => receiver,
                  :from => 'delivery@shareabanana.com',
                  :subject => "You have received a banana from #{sender}!",
                  :html_body => body,
                  :reply_to => sender,
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

    def get_ayah_code
      AYAH::Integration.new(ENV['AYAH_PUBLISHER'], ENV['AYAH_SCORING']).get_publisher_html
    end
  end
  
  get '/' do
    @ayah = get_ayah_code
    erb :index
  end

  post '/request' do
    session_secret = params[:session_secret]
    ayah = AYAH::Integration.new(ENV['AYAH_PUBLISHER'], ENV['AYAH_SCORING'])

    unless params[:receiving].validate(settings.email_regex)
      @receiving_error = "Your 'receiving email' field contained invalid data (#{params[:receiving]})."
    end

    unless params[:sending].validate(settings.email_regex)
      @sending_error = "Your 'sending email' field contained invalid data (#{params[:sending]})."
    end

    unless ayah.score_result(session_secret, CLIENT_IP)
      @ayah_error = "You don't appear to be a human."
    end

    if @receiving_error || @sending_error || @ayah_error
      erb :error
    else
      # generate_conf_link params[:receiving], params[:sending]
      banana_email params[:sending], params[:receiving]#, conf_link
      erb :request
    end
  end

  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end
end

