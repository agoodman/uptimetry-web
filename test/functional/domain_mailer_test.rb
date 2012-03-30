require 'test_helper'

class DomainMailerTest < ActionMailer::TestCase

  test "notify" do
    @user = Factory(:user, first_name: 'test', last_name: 'test', email: 'test@test.com', password: 'password')
    @domain = Factory(:domain, user: @user)
    @endpoint = Factory(:endpoint, domain: @domain, url: 'http://test.com/path/to/resource', email: 'to@example.org')
    mail = DomainMailer.notify(@endpoint)
    assert_equal "Notify", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match /Your site \(.+\) failed to respond at .+/, mail.body.encoded
  end

end
