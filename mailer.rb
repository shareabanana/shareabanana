require 'action_mailer'

ActionMailer::Base.template_root = File.dirname(__FILE__)
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => "smtp.sendgrid.net",
  :port => '25',
  :domain => 'heroku.com',
  :authentication => :plain,
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD']
}

class BananaMailer < ActionMailer::Base
  def banana_email sender, receiver
    banana = Dir.glob('public/img/bananas/img/*').sample

    from "delivery@shareabanana.com"
    recipients receiver
    subject "You have received a banana from #{sender}!"
    body :banana => banana
  end
end
