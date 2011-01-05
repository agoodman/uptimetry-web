class SiteMailer < ActionMailer::Base
  default :from => "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_mailer.notify.subject
  #
  def notify(site,time=Time.now)
    @site = site
    @time = time

    mail :to => site.email
  end
  
end
