require 'mail'

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

class BananaMailer
  def banana_email sender, receiver
    Mail.deliver do
      @banana = Dir.glob('public/img/bananas/img/*').sample
      
      from "delivery@shareabanana.com"
      to receiver
      subject "You have received a banana from #{sender}!"

      html_part do
        content_type 'text/html; charset=UTF-8'
        body erb(:banana_email, :layout => false)
      end
    end
  end
end
