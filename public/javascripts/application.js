// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function() {
	jQuery('#payment_form').submit(function(event) {
		jQuery('#payment_form input.button').attr("disabled", "disabled");

		var number = jQuery('#payment_form .card-number').val();
		var month = jQuery('#payment_form .card-exp-month').val();
		var year = jQuery('#payment_form .card-exp-year').val();
		var cvc = jQuery('#payment_form .card-cvc').val();
		var amount = jQuery('#payment_form .card-amount').val();

		Stripe.createToken({
			number: number,
			cvc: cvc,
			exp_month: month,
			exp_year: year
		}, amount, stripeResponseHandler);

		return false;
	});
});

function selectPlan(identifier,amount,prettyAmount) {
	jQuery('#payment_form p.amount').html('<label>Amount:</label> '+prettyAmount);
	jQuery('#plan_id').val(identifier);
	jQuery('#plan_amount').val(amount);
	jQuery('#credit_card').dialog({modal:true,title:'Enter Payment Information',width:'400px'});
}

function stripeResponseHandler(status, response) {
	if( response.error ) {
		jQuery('#payment_form input.button').removeAttr("disabled");
		jQuery('#payment_form .errors').html(response.error.message);
	}else{
		var token = response['id'];
		jQuery('#plan_token').val(token);
		jQuery('#payment_form').get(0).submit();
	}
}
