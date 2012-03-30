class DomainMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.endpoint_mailer.notify.subject
  #
  def notify(endpoint,time=Time.now)
    @endpoint = endpoint
    @time = time

    mail :to => endpoint.email
  end
  
end
