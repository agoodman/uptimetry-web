require 'test_helper'

class SiteMailerTest < ActionMailer::TestCase

  test "notify" do
    @user = User.create(:first_name => 'test', :last_name => 'test', :email => 'test', :password => 'password', :password_confirmation => 'password', :email_confirmed => true)
    @site = Site.create(:user_id => @user.id, :url => 'http://test', :email => 'to@example.org')
    mail = SiteMailer.notify(@site)
    assert_equal "Notify", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match /Your site \(.+\) failed to respond at .+/, mail.body.encoded
  end

end
