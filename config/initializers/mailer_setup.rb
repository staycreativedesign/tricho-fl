ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address                      => "smtp.gmail.com",
:port                            => 587,
:domain                       => "staycreativedesign.com",
:user_name                 => "gustavoanalytics@gmail.com",
:password                   => "rz30^4611",
:authentication           => :plain,
:enable_starttls_auto   => true
}