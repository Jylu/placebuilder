require "letter_opener"

$MailDeliveryMethod = ENV['mail_delivery_method'].try(:intern) || LetterOpener::DeliveryMethod

$MailDeliveryOptions =
  if $MailDeliveryMethod == LetterOpener::DeliveryMethod
    # {:location => Rails.root.join('tmp','inboxes')}
    puts "E-mails are being delivered to tmp/inboxes!"
    {:location => Rails.root.join('tmp','inboxes')}
  else
    {
    :address => ENV['mail_address'],
    :port => ENV['mail_port'],
    :domain => ENV['domain'],
    :authentication => ENV['mail_authentication'],
    :user_name => ENV['mail_username'],
    :password => ENV['mail_password']
    }
  end
