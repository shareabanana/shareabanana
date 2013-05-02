require 'sinatra'
require 'coinbase'
require 'pony'
require 'rack/recaptcha'
require 'json'
require './database.rb'

=begin
COINBASE_API_KEY
COINBAE_CALLBACK_SECRET
RECAPTCHA_PUBLIC
RECAPTCHA_PRIVATE
SENDGRID_USERNAME
SENDGRID_PASSWORD
HEROKU_POSTGRESQL_WHITE_URL
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

    use Rack::Recaptcha, :public_key => ENV['RECAPTCHA_PUBLIC'], :private_key => ENV['RECAPTCHA_PRIVATE']
    helpers Rack::Recaptcha::Helpers
  end
  
  helpers do
    def random_key
      o =  [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
      (0...50).map{ o[rand(o.length)] }.join
    end

    def mail_helper subj, body, from_address, to_address
      conf = {
        :to => to_address,
        :from => 'delivery@shareabanana.com',
        :subject => subj,
        :html_body => body,
        :reply_to => from_address,
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
      }

      Pony.mail conf
    end

    def confirm_email from_address, from_name, to_address
      t = Transaction.new :from_address => from_address, :from_name => from_name, :to_address => to_address
      k = Confirmation.new :ckey => random_key
      t.confirmation = k
      k.save!
      t.save!

      @key = random_key

      body = erb(:confirm_email, :layout => false)
      subj = "Confirm your email, #{from_name} :)"

      mail_helper subj, body, from_address, from_address
    end
    
    def banana_email from_address, from_name, to_address
      @banana = File.basename Dir.glob('public/img/bananas/*').sample
      body = erb(:banana_email, :layout => false)
      subj = "#{from_name} has shared a banana with you!"

      mail_helper subj, body, from_address, to_address
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
      confirm_email params[:sending_address], params[:sending_name], params[:receiving_address]
      erb :request
    end
  end

  get '/confirm/:key' do
    k = Confirmation.first :ckey => params[:key]
    t = Transaction.first :confirmation => k
    banana_email t.from_address, t.from_name, t.to_address
    k.destroy
    erb :confirmed
  end
  
  get '/balance' do
    return settings.coinbase.balance.to_f.to_s
  end

  get "/payment/#{ENV['COINBASE_CALLBACK_SECRET']}" do
    order = JSON.parse params[:order]
    return order
  end

  get '/success' do
    #hello
  end
end
