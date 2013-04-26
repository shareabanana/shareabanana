class BananaMailer
  smtp = {
    :address => "smtp.sendgrid.net",
    :port => '25',
    :domain => 'heroku.com',
    :authentication => :plain,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :enable_starttls_auto => true,
    :openssl_verify_mode => 'none'
  }
  
  Mail.defaults {
    delivery_method :smtp, smtp
  }
  
  def self.banana_email sender, receiver
    @banana = Dir.glob('public/img/bananas/img/*').sample
    @body = erb(:banana_email, :layout => false)

    Mail.deliver do
      from "delivery@shareabanana.com"
      to receiver
      subject "You have received a banana from #{sender}!"
      
      html_part do
        content_type 'text/html; charset=UTF-8'
        body @body
      end
    end
  end
end
