// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
	$('#payment_form').submit(function(event) {
		$('#payment_form input.button').attr("disabled", "disabled");

		var number = $('#payment_form .card-number').val();
		var month = $('#payment_form .card-exp-month').val();
		var year = $('#payment_form .card-exp-year').val();
		var cvc = $('#payment_form .card-cvc').val();
		var amount = $('#payment_form .card-amount').val();

		Stripe.createToken({
			number: number,
			cvc: cvc,
			exp_month: month,
			exp_year: year
		}, amount, stripeResponseHandler);

		return false;
	});
	uiHooks();
});

function uiHooks() {
	$('.button.pencil').button({icons:{primary:'ui-icon-pencil'},text:false});
	$('.button.trash').button({icons:{primary:'ui-icon-trash'},text:false});
	$('.button.wrench').button({icons:{primary:'ui-icon-wrench'},text:false});
	$('.button.refresh').button({icons:{primary:'ui-icon-refresh'},text:false});
	$('.button').button();
	$('.datepicker').datepicker();
}

function selectPlan(identifier,amount,prettyAmount) {
	$('#payment_form p.amount').html('<label>Due Now:</label> '+prettyAmount+'<br/><small>billed monthly until canceled</small>');
	$('#plan_id').val(identifier);
	$('#plan_amount').val(amount);
	$('#credit_card').dialog({modal:true,title:'Enter Payment Information',width:'400px'});
}

function stripeResponseHandler(status, response) {
	if( response.error ) {
		$('#payment_form input.button').removeAttr("disabled");
		$('#payment_form .errors').html(response.error.message);
	}else{
		var token = response['id'];
		$('#plan_token').val(token);
		$('#payment_form').get(0).submit();
	}
}
