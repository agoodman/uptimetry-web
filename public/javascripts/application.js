// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function() {
	jQuery('#payment_form').submit(function(event) {
		jQuery('#payment_form input.button').attr("disabled", "disabled");
		
		Stripe.createToken({
			number: jQuery('#payment_form .card-number').val(),
			cvc: jQuery('#payment_form .card-cvc').val(),
			exp_month: jQuery('#payment_form .card-exp-month').val(),
			exp_year: jQuery('#payment_form .card-exp-year').val()
		}, jQuery('#payment_form .amount'), stripeResponseHandler);
		
		return false;
	})
});

function choosePlan(identifier,amount,prettyAmount) {
	jQuery('#credit_card input.identifier').val(identifier);
	jQuery('#credit_card p.amount').html('<label>Amount:</label> '+prettyAmount);
	jQuery('#credit_card input.amount').val(amount);
	jQuery('#plan_id').val(identifier);
	jQuery('#plan_amount').val(amount);
	jQuery('#credit_card').dialog({modal:true,title:'Enter Payment Information',width:'600px'});
}

function stripeResponseHandler(status, response) {
	if( response.error ) {
		alert(response.error.message);
	}else{
		var token = response['id'];
		jQuery('#plan_token').val(token);
		jQuery('#payment_form').hide();
		jQuery('#select_plan').show();
	}
}
