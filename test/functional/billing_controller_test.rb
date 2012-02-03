require 'test_helper'

class BillingControllerTest < ActionController::TestCase

  # context "on post post_back for recurring_payment_succeeded event" do
  #   setup do
  #     @user = Factory(:user, customer_reference: "abc123")
  #     post :post_back, :json => {
  #       "customer": "abc123",
  #       "livemode": true,
  #       "event": "recurring_payment_succeeded",
  #       "invoice": {
  #         "total": 2000,
  #         "subtotal": 2000,
  #         "charge": "ch_sUmNHkMiag",
  #         "lines": {
  #           "subscriptions": [
  #           {
  #             "amount": 2000,
  #             "period": {
  #               "start": 1304588585,
  #               "end": 1307266985
  #             },
  #             "plan": {
  #               "amount": 2000,
  #               "interval": "month",
  #               "object": "plan",
  #               "id": "test.uptimetry.mini",
  #               "name": "Mini test plan"
  #             }
  #           }
  #           ]
  #         },
  #         "object": "invoice",
  #         "date": 1304588585,
  #         "period_start": 1304588585,
  #         "id": "in_jN6A1g8N76",
  #         "period_end": 1304588585
  #       },
  #       "payment": {
  #         "time": 1297887533,
  #         "card":
  #         {
  #           "type": "Visa",
  #           "last4": "4242"
  #         },
  #         "success": true
  #       }
  #     }
  #   end
  #   should respond_with :success
  # end

end
