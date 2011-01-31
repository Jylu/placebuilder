require 'smtp_api_header.rb'

class QuestionMailer < ActionMailer::Base
  
  helper :text
  helper_method :url
  include TextHelper

  include Resque::Mailer
  @queue = :notifications
  
  def faq(from, body)
    @from = from
    @body = body
    recipients "jason@jasonberlinsky.com"
    header = SmtpApiHeader.new
    @headers['X-SMTPAPI'] = header.asJSON
    subject "New Question for you!"
    from "CommonPlace <do-not-reply@commonplaceusa.com>"
  end
  
end
