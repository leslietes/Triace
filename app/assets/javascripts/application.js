// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
jQuery.ajaxSetup({  
    'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
});  

$(document).ready(function() {
        $("input:visible:first").focus();

        $('#customers').dataTable({
                "aLengthMenu": [[-1, 25, 50], ["All", 25, 50]],
		"iDisplayLength": "-1"
        });
        $('#products').dataTable({
                "aLengthMenu": [[-1, 25, 50], ["All", 25, 50]],
		"iDisplayLength": "-1"
        });
        $('#orders').dataTable({
                "aLengthMenu": [[-1, 25, 50], ["All", 25, 50]],
		"iDisplayLength": "-1"
        });
        $('#inventories').dataTable({
                "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]],
		"iDisplayLength": "-1"
        });
        $('#payments').dataTable({
                "aLengthMenu": [[-1, 25, 50], ["All", 25, 50]],
		"iDisplayLength": "-1"
        });

	$('ul.sf-menu').superfish();
	
	$('.calendar').datepicker({
		changeYear: true,
		changeMonth: true,
		dateFormat: 'MM dd, yy'
	});

        $('.search_form').datepicker({
		changeYear: true,
		changeMonth: true,
		dateFormat: 'yy-mm-dd'
	});
	
        /*$("#order_detail_product_id").change(function(value){
            var product = $(this).find('option:selected').val();
            jQuery.get('/product/get_order_info/' + product, function(data){
		$('#unit_price').html(data);
	    });
	    return false;
        }); */

        $("#product_id").change(function(value){
            var product = $(this).find('option:selected').val();
            $.ajax({
                url: '/product/get_price/' + product
            })
	    return true;
        });

	/*$('#autocomplete_department').autocomplete({
		source: "/request_payments/autocomplete_dept.json",
		select: function(event,ui){
          $('#department_id').val(ui.item.id)}
	});
	
	$('#autocomplete_payee').autocomplete({
		source: "/request_payments/autocomplete_payee.json",
		select: function(event,ui){
          $('#payee_id').val(ui.item.id)}
	});
	
	$('#autocomplete_account').autocomplete({
		source:"/request_payments/autocomplete_acc.json",
		select: function(event,ui){
		  $('#account_id').val(ui.item.id)}
	})*/;
})
