// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui

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
