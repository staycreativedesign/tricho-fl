class UserMailer < ActionMailer::Base
  default from: "gustavoanalytics@gmail.com"
  default to: "gustavoanalytics@gmail.com"

  def welcome_email(message)
    @message = message
    mail(subject: 'Tricho Contact information')
    
  end
end
